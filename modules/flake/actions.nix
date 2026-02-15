{
  self,
  lib,
  inputs,
  ...
}:
let
  runners = {
    x86_64-linux = "ubuntu-latest";
    aarch64-linux = "ubuntu-24.04-arm";
  };

  nixosHosts = lib.mapAttrsToList (
    name: config:
    let
      hostPlatform = config.pkgs.stdenv.hostPlatform.system;
    in
    {
      hostname = name;
      output = "nixosConfigurations.${name}.config.system.build.toplevel";
      inherit hostPlatform;
      runsOn = runners.${hostPlatform};
    }
  ) self.nixosConfigurations or { };

  flakeRef = "git+file:.";

  checkPlatforms = lib.unique (map (c: { inherit (c) runsOn hostPlatform; }) nixosHosts);

  actions = {
    checkout = "actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd"; # v6.0.2
    nothing-but-nix = "wimpysworld/nothing-but-nix@687c797a730352432950c707ab493fcc951818d7"; # v10
    install-nix-action = "cachix/install-nix-action@2126ae7fc54c9df00dd18f7f18754393182c73cd"; # v31.9.1
    cache-nix-action = "nix-community/cache-nix-action@7df957e333c1e5da7721f60227dbba6d06080569"; # v7
    nix-diff-action = "natsukium/nix-diff-action@374bf5037dc84fc520da2002beef2f2bd96f4e9b"; # v1.0.2
    alls-green = "re-actors/alls-green@05ac9388f0aebcb5727afa17fcccfecd6f8ec5fe"; # v1.2.2
    automerge = "peter-evans/enable-pull-request-automerge@a660677d5469627102a1c1e11409dd063606628d"; # v3.0.0
    create-github-app-token = "actions/create-github-app-token@7e473efe3cb98aa54f8d4bac15400b15fad77d94"; # v2.2.0
  };

  steps = {
    checkout = {
      name = "Checkout";
      uses = actions.checkout;
      "with".token = "\${{ secrets.GITHUB_TOKEN }}";
    };
    purge = {
      name = "Purge non-Nix files";
      uses = actions.nothing-but-nix;
      "with".hatchet-protocol = "rampage";
    };
    installNix = {
      name = "Install Nix";
      uses = actions.install-nix-action;
      "with".github_access_token = "\${{ secrets.GITHUB_TOKEN }}";
    };
    nixCache = {
      name = "Setup Nix cache";
      uses = actions.cache-nix-action;
      "with" = {
        primary-key = "nix-\${{ runner.os }}-\${{ hashFiles('**/*.nix', '**/flake.lock') }}";
        restore-prefixes-first-match = "nix-\${{ runner.os }}-";
        gc-max-store-size-linux = "5G";
        purge = true;
        purge-prefixes = "nix-\${{ runner.os }}-";
        purge-created = 0;
        purge-last-accessed = 0;
        purge-primary-key = "never";
      };
    };
    removeUnbuildable = {
      name = "Remove unbuildable modules";
      run = ''
        rm -f \
          modules/vmware.nix \
          modules/school/cisco.nix
      '';
    };
    nixFastBuild = flakeAttr: {
      name = "Fast nix build";
      run = ''
        nix run nixpkgs#nix-fast-build -- --no-nom --skip-cached --retries=3 --option accept-flake-config true --flake="${flakeRef}#${flakeAttr}"
      '';
    };
    generateAppToken = {
      name = "Generate App Token";
      id = "app-token";
      uses = actions.create-github-app-token;
      "with" = {
        app-id = "\${{ secrets.APP_ID }}";
        private-key = "\${{ secrets.APP_PRIVATE_KEY }}";
      };
    };
  };

  commonSteps = [
    steps.checkout
    steps.purge
    steps.installNix
    steps.nixCache
    steps.removeUnbuildable
  ];
in
{
  imports = [ inputs.actions-nix.flakeModules.default ];
  flake.actions-nix = {
    pre-commit.enable = true;
    defaultValues = {
      jobs = {
        timeout-minutes = 60;
        runs-on = "ubuntu-latest";
      };
    };
    workflows = {
      ".github/workflows/ci.yaml" = {
        name = "CI";
        on = {
          push.branches = [
            "main"
            "testing-*"
          ];
          pull_request = { };
          workflow_dispatch = { };
        };

        concurrency = {
          group = "ci-\${{ github.head_ref || github.ref_name }}";
          cancel-in-progress = "\${{ github.event_name == 'pull_request' }}";
        };

        jobs = {
          flake-check = {
            name = "Flake check \${{ matrix.systems.hostPlatform }}";
            strategy.matrix.systems = checkPlatforms;
            runs-on = "\${{ matrix.systems.runsOn }}";
            steps = commonSteps ++ [
              {
                name = "nix flake check";
                run = "nix flake check '${flakeRef}'";
              }
              {
                name = "nix flake show";
                run = "nix flake show '${flakeRef}'";
              }
            ];
          };

          build = {
            name = "Build \${{ matrix.attrs.hostname }} (\${{ matrix.attrs.hostPlatform }})";
            strategy = {
              fail-fast = false;
              matrix.attrs = nixosHosts;
            };
            runs-on = "\${{ matrix.attrs.runsOn }}";
            steps = commonSteps ++ [ (steps.nixFastBuild "\${{ matrix.attrs.attr }}") ];
          };

          check = {
            name = "All checks";
            runs-on = "ubuntu-latest";
            needs = [
              "flake-check"
              "build"
            ];
            "if" = "always()";
            steps = [
              {
                uses = actions.alls-green;
                "with" = {
                  jobs = "\${{ toJSON(needs) }}";
                };
              }
            ];
          };
        };
      };

      ".github/workflows/diff.yaml" = {
        name = "Diff";
        on = {
          pull_request = { };
          workflow_dispatch = { };
        };

        concurrency = {
          group = "diff-\${{ github.head_ref || github.ref_name }}";
          cancel-in-progress = "\${{ github.event_name == 'pull_request' }}";
        };

        jobs = {
          generate-diffs = {
            name = "Generate Diff (\${{ matrix.attrs.hostname}})";
            runs-on = "\${{ matrix.attrs.runsOn }}";
            permissions.contents = "read";
            strategy = {
              fail-fast = false;
              matrix.attrs = nixosHosts;
            };
            steps = commonSteps ++ [
              {
                name = "Generate diff (\${{ matrix.attrs.hostname }})";
                uses = actions.nix-diff-action;
                "with" = {
                  mode = "diff-only";
                  attributes = ''
                    - displayName: ''${{ matrix.attrs.hostname }}
                      attribute: ''${{ matrix.attrs.output }}
                  '';
                };
              }
            ];
          };
          post-diff-comment = {
            name = "Post comment";
            runs-on = "ubuntu-latest";
            needs = [ "generate-diffs" ];
            permissions = {
              actions = "read";
              pull-requests = "write";
            };
            steps = [
              {
                name = "Post diff comment";
                uses = actions.nix-diff-action;
                "with".mode = "comment-only";
              }
            ];
          };
        };
      };
      ".github/workflows/regenerate-workflows.yaml" = {
        name = "Regenerate workflows";
        on = {
          pull_request.paths = [
            "modules/flake/actions.nix"
            "flake.lock"
          ];
          workflow_dispatch = { };
        };

        permissions = {
          contents = "write";
          pull-requests = "write";
        };

        jobs.regenerate = {
          runs-on = "ubuntu-latest";
          # Only run for Renovate PRs or manual dispatch
          "if" = "github.actor == 'renovate[bot]' || github.event_name == 'workflow_dispatch'";
          steps = [
            steps.generateAppToken
            (
              steps.checkout
              // {
                "with" = {
                  ref = "\${{ github.head_ref || github.ref_name }}";
                  token = "\${{ steps.app-token.outputs.token }}";
                  fetch-depth = 2;
                };
              }
            )
            steps.installNix
            steps.nixCache
            {
              name = "Regenerate workflows";
              run = "nix run .#render-workflows";
            }
            {
              name = "Format code";
              run = "nix fmt";
            }
            {
              name = "Amend commit with regenerated workflows";
              run = ''
                git config user.name "mrsom3body-bot[bot]"
                git config user.email "261862837+MrSom3body-Bot[bot]@users.noreply.github.com"
                git add .github/workflows/
                git diff --staged --quiet || git commit --amend --no-edit
                git push --force-with-lease
              '';
            }
            {
              uses = actions.automerge;
              "with" = {
                token = "\${{ steps.app-token.outputs.token }}";
                pull-request-number = "\${{ github.event.pull_request.number }}";
                merge-method = "rebase";
              };
            }
          ];
        };
      };
    };
  };
}
