{
  description = "Flake using uv2nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;

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
    packages.x86_64-linux.default = pythonSet.mkVirtualEnv "python-env" workspace.deps.default;

    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = [
        python
        pkgs.uv
      ];
      env =
        {
          # Prevent uv from managing Python downloads
          UV_PYTHON_DOWNLOADS = "never";
          # Force uv to use nixpkgs Python interpreter
          UV_PYTHON = python.interpreter;
        }
        // lib.optionalAttrs pkgs.stdenv.isLinux {
          # Python libraries often load native shared objects using dlopen(3).
          # Setting LD_LIBRARY_PATH makes the dynamic library loader aware of libraries without using RPATH for lookup.
          LD_LIBRARY_PATH = lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
        };
      shellHook = ''
        unset PYTHONPATH
      '';
    };
  };
}
