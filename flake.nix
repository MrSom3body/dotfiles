{
  description = "MrSom3body's flake";

  outputs = {
    self,
    nixpkgs,
    systems,
    deploy-rs,
    ...
  } @ inputs: let
    inherit (import ./settings.nix) settings;
    inherit (nixpkgs) lib;
    inherit (self) outputs;

    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );

    specialArgs = {
      inherit self;
      inherit inputs;
      inherit outputs;
    };

    mkNixos = {
      hostname,
      isInstall ? true,
    }:
      lib.nixosSystem {
        specialArgs =
          specialArgs
          // {
            settings = settings hostname;
            inherit isInstall;
          };

        modules =
          [
            ./hosts/${hostname}
          ]
          ++ (
            if isInstall
            then [
              ./hosts/${hostname}/disko.nix
              inputs.disko.nixosModules.disko
            ]
            else []
          );
      };
  in {
    overlays = import ./overlays {
      inherit inputs;
      inherit outputs;
    };
    packages = forEachSystem (pkgs:
      import ./pkgs {
        inherit outputs;
        inherit pkgs;
      });
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      blackbox = mkNixos {hostname = "blackbox";};
      pandora = mkNixos {hostname = "pandora";};

      sanctuary = mkNixos {
        hostname = "sanctuary";
        isInstall = false;
      };
    };

    deploy.nodes = {
      pandora = {
        hostname = "pandora";
        profiles.system = {
          sshUser = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos outputs.nixosConfigurations.pandora;
        };
      };
    };

    devShells = forEachSystem (pkgs:
      import ./shell.nix {
        inherit self;
        inherit inputs;
        inherit pkgs;
      });
    checks =
      builtins.mapAttrs (_system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib
      // forEachSystem (pkgs:
        import ./checks.nix {
          inherit inputs;
          inherit pkgs;
        });
  };

  inputs = {
    # global, so they can be `.follow`ed
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";
    systems.url = "github:nix-systems/default-linux";

    flake-compat = {
      url = "github:edolstra/flake-compat";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # nix ecosystem
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        flake-compat.follows = "flake-compat";
        utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        pre-commit-hooks-nix.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks-nix";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # programs
    ghostty.url = "github:ghostty-org/ghostty"; # has cache

    gotcha = {
      url = "github:MrSom3body/gotcha";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix.url = "github:helix-editor/helix"; # has cache

    tailray = {
      url = "github:NotAShelf/tailray";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi.url = "github:sxyazi/yazi"; # has cache

    # hyprland stuff
    hyprland.url = "github:hyprwm/hyprland";
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprland-protocols.follows = "hyprland/hyprland-protocols";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs = {
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    pyprland = {
      url = "github:hyprland-community/pyprland";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    # non flakes
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };

    yazi-starship-plugin = {
      url = "github:Rolv-Apneseth/starship.yazi";
      flake = false;
    };
  };
}
