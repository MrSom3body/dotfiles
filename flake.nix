{
  description = "MrSom3body's flake";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    ...
  } @ inputs: let
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
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      name = "dotfiles";

      inherit (self.checks.${system}.pre-commit-check) shellHook;
      buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;

      packages = with pkgs; [
        alejandra
        git
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

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    helix.url = "github:helix-editor/helix";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyprland.url = "github:hyprland-community/pyprland";

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
