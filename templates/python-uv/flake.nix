{
  description = "Flake using uv2nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs = {
        pyproject-nix.follows = "pyproject-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs = {
        pyproject-nix.follows = "pyproject-nix";
        uv2nix.follows = "uv2nix";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    forEachSystem = f: lib.genAttrs (import inputs.systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import inputs.systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );

    workspace = inputs.uv2nix.lib.workspace.loadWorkspace {workspaceRoot = ./.;};

    overlay = workspace.mkPyprojectOverlay {
      sourcePreference = "wheel";
    };

    # Extend generated overlay with build fixups
    #
    # Uv2nix can only work with what it has, and uv.lock is missing essential metadata to perform some builds.
    # This is an additional overlay implementing build fixups.
    # See:
    # - https://pyproject-nix.github.io/uv2nix/FAQ.html
    pyprojectOverrides = _final: _prev: {
      # Implement build fixups here.
      # Note that uv2nix is _not_ using Nixpkgs buildPythonPackage.
      # It's using https://pyproject-nix.github.io/pyproject.nix/build.html
    };

    pkgs = nixpkgs.legacyPackages.x86_64-linux;

    python = pkgs.python313;

    pythonSet =
      (pkgs.callPackage inputs.pyproject-nix.build.packages {
        inherit python;
      }).overrideScope
      (
        lib.composeManyExtensions [
          inputs.pyproject-build-systems.overlays.default
          overlay
          pyprojectOverrides
        ]
      );
  in {
    packages = forEachSystem (_pkgs: {
      default = pythonSet.mkVirtualEnv "python-env" workspace.deps.default;
    });

    devShells = forEachSystem (pkgs:
      import ./nix/shell.nix {
        inherit self lib pkgs python;
      });

    checks = forEachSystem (pkgs:
      import ./nix/checks.nix {
        inherit inputs;
        inherit pkgs;
      });
  };
}
