{
  description = "MrSom3body's flake";

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-stable,
    stylix,
    ...
  }: let
    inherit (import ./settings.nix) dotfiles;

    lib = nixpkgs.lib;
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
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
          (import ./overlays.nix)
          {nixpkgs.pkgs = pkgs;}

          ./hosts/${dotfiles.hostname}
          {
            home-manager.users.${dotfiles.username}.imports = [./hosts/${dotfiles.hostname}/home.nix];
          }
          stylix.nixosModules.stylix
        ];
      };
    };

    devShells."x86_64-linux".default = pkgs.mkShell {
      name = "dotfiles";

      packages = with pkgs; [
        alejandra
        git
        lua-language-server
      ];
    };
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
