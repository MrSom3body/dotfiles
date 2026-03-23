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
    install-nix-action = "cachix/install-nix-action@51f3067b56fe8ae331890c77d4e454f6d60615ff"; # v31.10.2
    cachix = "cachix/cachix-action@1eb2ef646ac0255473d23a5907ad7b04ce94065c"; # v17
    nix-diff-action = "natsukium/nix-diff-action@65526931655c9561dfdb1330b8770d1673857ae9"; # v1.0.3
    alls-green = "re-actors/alls-green@05ac9388f0aebcb5727afa17fcccfecd6f8ec5fe"; # v1.2.2
    upload-artifact = "actions/upload-artifact@bbbca2ddaa5d8feaa63e36b76fdaad77386f024f"; # v7
    action-gh-release = "softprops/action-gh-release@153bb8e04406b158c6c84fc1615b65b24149a1fe"; # v2.6.1
    download-artifact = "actions/download-artifact@3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c"; # v8.0.1
    create-pull-request = "peter-evans/create-pull-request@c0f553fe549906ede9cf27b5156039d195d2ece0"; # v8.1.0
    create-github-app-token = "actions/create-github-app-token@f8d387b68d61c58ab83c6c016672934102569859"; # v3
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
      "with" = {
        github_access_token = "\${{ secrets.GITHUB_TOKEN }}";
        extra_nix_config = ''
          always-allow-substitutes = true
          builders-use-substitutes = true
          max-jobs = auto
        '';
      };
    };
    cachix = {
      name = "Setup Cachix";
      uses = actions.cachix;
      "with" = {
        name = "som3cache";
        authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
        extraPullNames = "nix-community";
      };
    };
    removeUnbuildable = {
      name = "Remove unbuildable files";
      run = "rm -f modules/vmware.nix modules/school/cisco.nix";
    };
    nixFastBuild = flakeAttr: {
      name = "Nix build";
      run = ''
        nix develop --command -- nix-fast-build \
          --no-nom \
          --skip-cached \
          --retries=3 \
          --cachix-cache som3cache \
          --flake="${flakeRef}#${flakeAttr}"
      '';
      env.CACHIX_AUTH_TOKEN = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
    };
    uploadArtifacts = data: {
      name = "Upload artifacts";
      uses = actions.upload-artifact;
      "with" = data;
    };
    downloadArtifacts = data: {
      name = "Download artifacts";
      uses = actions.download-artifact;
      "with" = data;
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
    createPullRequest = data: {
      name = "Create PR";
      uses = actions.create-pull-request;
      id = "create-pr";
      "with" = {
        token = "\${{ steps.app-token.outputs.token }}";
        delete-branch = true;
      }
      // data;
    };
    automerge = pr: {
      name = "Auto Merge PR (\${{ ${pr} }})";
      env.GH_TOKEN = "\${{ steps.app-token.outputs.token }}";
      run = ''
        if [ -n "''${{ ${pr} }}" ]; then
          gh pr merge --auto --rebase ''${{ ${pr} }}
        fi
      '';
    };
  };

  commonSteps = [
    steps.checkout
    steps.purge
    steps.installNix
    steps.cachix
  ];
in
{
  imports = [ inputs.actions-nix.flakeModules.default ];
  flake.actions-nix = {
    pre-commit.enable = true;
    defaultValues = {
      jobs = {
        runs-on = runners.x86_64-linux;
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
            name = "Flake check (\${{ matrix.systems.hostPlatform }})";
            strategy = {
              fail-fast = false;
              matrix.systems = checkPlatforms;
            };
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
            steps = commonSteps ++ [
              steps.removeUnbuildable
              (steps.nixFastBuild "\${{ matrix.attrs.output }}")
            ];
          };

          check = {
            name = "All checks";
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
          pull_request.paths = [ "flake.lock" ];
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

      ".github/workflows/iso-build.yaml" = {
        name = "ISO Build";
        on = {
          schedule = [ { cron = "0 0 * * mon"; } ];
          workflow_dispatch = { };
        };

        jobs = {
          build-images = {
            name = "Build ISO (\${{ matrix.image }})";
            strategy.matrix.image = [ "sanctuary" ];
            steps = commonSteps ++ [
              (steps.nixFastBuild "images.\${{ matrix.image }}")
              (steps.uploadArtifacts {
                name = "\${{ matrix.image }}-iso-image";
                path = "result-/iso/*.iso";
              })
            ];
          };
          publish-images = {
            name = "Publish ISOs";
            needs = [ "build-images" ];
            permissions.contents = "write";
            env.GITHUB_TOKEN = "\${{ secrets.GITHUB_TOKEN }}";
            steps = [
              (steps.downloadArtifacts { merge-multiple = true; })
              {
                name = "Generate date";
                id = "get-date";
                run = ''echo "date=$(date +'%Y-%m-%d-%H%M%S')" >> "''${GITHUB_OUTPUT}"'';
              }
              {
                name = "Generate checksums";
                run = "sha256sum *.iso > checksums.txt";
              }
              {
                name = "Create release";
                uses = actions.action-gh-release;
                "with" = {
                  name = "🛠  Weekly ISO Release — \${{ steps.get-date.outputs.date }}";
                  tag_name = "iso-\${{ steps.get-date.outputs.date }}";
                  files = ''
                    *.iso
                    checksums.txt
                  '';
                  body = ''
                    > [!CAUTION]
                    > These ISOs have my public keys added. This means I can SSH into them without any password.

                    These ISOs are built straight from my NixOS configs in [MrSom3body/dotfiles](https://github.com/MrSom3body/dotfiles) and meant **only** for me to be able to just plug these in and run `nixos-anywhere`.

                    ## 📦 What’s inside

                    | Image         | Purpose                                      |
                    | ------------- | -------------------------------------------- |
                    | **sanctuary** | ISO to install NixOS with my public SSH keys |

                    ## 🔒 Verify checksum

                    ```bash
                    sha256sum -c checksums.txt
                    ```
                  '';
                };
              }
            ];
          };
        };
      };

      ".github/workflows/topology-update.yaml" = {
        name = "Topology Update";
        on = {
          schedule = [ { cron = "0 0 1,15 * *"; } ];
          workflow_dispatch = { };
        };

        jobs = {
          update-topology = {
            steps = commonSteps ++ [
              steps.generateAppToken
              {
                name = "Build topology";
                run = "nix build .#topology.x86_64-linux.config.output";
              }
              {
                name = "Generate WebP";
                run = "nix run nixpkgs#librsvg -- -o .github/assets/topology.webp ./result/main.svg";
              }
              (steps.createPullRequest {
                commit-message = "assets: update topology image";
                title = "assets: update topology image";
                body = "This PR updates the network topology image generated from the latest Nix configuration.";
                labels = ''
                  automated
                '';
              })
              (steps.automerge "steps.create-pr.outputs.pull-request-number")
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
            steps.cachix
            {
              name = "Regenerate workflows";
              run = "nix run .#render-workflows";
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
            (steps.automerge "github.event.pull_request.number")
          ];
        };
      };
    };
  };
}
