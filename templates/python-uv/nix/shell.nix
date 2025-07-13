{
  self,
  lib,
  pkgs,
  python,
}: {
  default = pkgs.mkShell {
    packages =
      builtins.attrValues {
        inherit
          (pkgs)
          just
          uv
          ;
      }
      ++ [python];

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
      ${self.checks.${pkgs.system}.pre-commit-check.shellHook}
    '';
  };
}
