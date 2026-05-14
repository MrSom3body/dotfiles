{
  perSystem =
    { config, pkgs, ... }:
    let
      rustToolchain = pkgs.rust-bin.fromRustupToolchainFile ../rust-toolchain.toml;
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [ rustToolchain ];

        shellHook = ''
          ${config.pre-commit.settings.shellHook}
        '';
      };
    };
}
