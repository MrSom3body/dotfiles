{
  description = "MrSom3body's flake";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    ...
  } @ inputs: let
    inherit (import ./settings.nix) dotfiles;

    inherit (nixpkgs) lib;
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
    };

    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };

    specialArgs = {
      inherit pkgs-stable;
      inherit inputs;
      inherit dotfiles;
    };
  in {
    nixosConfigurations = {
      ${dotfiles.hostname} = lib.nixosSystem {
        inherit system;
        inherit specialArgs;
        modules = [
          ./hosts/${dotfiles.hostname}
        ];
      };
    };

    checks.${system}.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
      src = ./.;
      hooks = {
        alejandra.enable = true;
        deadnix.enable = true;
        markdownlint.enable = true;
        nil.enable = true;
        statix.enable = true;
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      name = "dotfiles";

      buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;

      packages = with pkgs; [
        alejandra
        git
        just
      ];

      shellHook = ''
        ${self.checks.${system}.pre-commit-check.shellHook}

        tput setaf 2; tput bold; echo -n "Git: "; tput sgr0; echo "last 5 commits"
        git log --all --decorate --graph --oneline -5
        echo
        tput setaf 2; tput bold; echo -n "Git: "; tput sgr0; echo "status"
        git status --short
      '';
    };
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.11";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    helix.url = "github:helix-editor/helix";

    hyprland.url = "github:hyprwm/hyprland";

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
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
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs = {
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyprland.url = "github:hyprland-community/pyprland";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
