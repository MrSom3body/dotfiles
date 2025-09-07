{
  description = "MrSom3body's dotfiles";

  outputs =
    {
      self,
      nixpkgs,
      systems,
      deploy-rs,
      ...
    }@inputs:
    let
      inherit (import ./settings.nix) settings;
      inherit (nixpkgs) lib;

      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );

      specialArgs = {
        inherit inputs;
      };

      mkNixos =
        hostname:
        lib.nixosSystem {
          specialArgs = specialArgs // {
            settings = settings hostname;
          };
          modules = [ ./hosts/${hostname} ];
        };
    in
    {
      overlays = import ./overlays {
        inherit inputs;
      };

      formatter = forEachSystem (pkgs: pkgs.nixfmt-tree);

      nixosConfigurations = {
        promethea = mkNixos "promethea";
        pandora = mkNixos "pandora";

        athenas = mkNixos "athenas";
        sanctuary = mkNixos "sanctuary";

        # hosts only for garnix
        promethea_garnix = mkNixos "promethea_garnix";
      };

      images = {
        sanctuary = self.nixosConfigurations.sanctuary.config.system.build.isoImage;
        athenas = self.nixosConfigurations.athenas.config.system.build.isoImage;
      };

      templates = {
        default = {
          path = ./templates/default;
          description = "my default dev template";
        };

        python-uv = {
          path = ./templates/python-uv;
          description = "a python uv dev template";
        };
      };

      deploy.nodes = {
        pandora = {
          hostname = "pandora";
          profiles.system = {
            sshUser = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.pandora;
          };
        };
      };

      devShells = forEachSystem (
        pkgs:
        import ./shell.nix {
          inherit inputs pkgs;
        }
      );
      checks =
        builtins.mapAttrs (_system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib
        // forEachSystem (
          pkgs:
          import ./checks.nix {
            inherit inputs pkgs;
          }
        );
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

    # my packages
    som3pkgs = {
      url = "github:MrSom3body/som3pkgs";
      inputs = {
        git-hooks-nix.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
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

    lanzaboote.url = "github:nix-community/lanzaboote";

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

    nixos-hardware.url = "github:MrSom3body/nixos-hardware/add-asus-um6702";

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
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # programs
    ghostty = {
      url = "github:ghostty-org/ghostty"; # has cache, but can't use it because of drivers :(
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

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
      inputs = {
        hyprland.follows = "hyprland";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
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

    helix-vim = {
      url = "github:chtenb/helix.vim";
      flake = false;
    };
  };
}
