{ inputs, ... }:
{
  perSystem =
    {
      system,
      config,
      pkgs,
      ...
    }:
    let
      typixLib = inputs.typix.lib.${system};

      src = ../.;
      commonArgs = {
        typstSource = "main.typ";

        fontPaths = [ "${pkgs.font-awesome}/share/fonts/opentype" ];

        virtualPaths = [ ];
      };

      unstable_typstPackages = [
        {
          name = "codly-languages";
          version = "0.1.10";
          hash = "sha256-rXK4TkLpw5mvGTPPVG9h2XMEJix+BsiR5JIAhURw/n0=";
        }
        {
          name = "codly";
          version = "1.3.0";
          hash = "sha256-WcqvySmSYpWW+TmZT7TgPFtbEHA+bP5ggKPll0B8fHk=";
        }
      ];

      # Compile a Typst project, *without* copying the result
      # to the current directory
      build-drv = typixLib.buildTypstProject (commonArgs // { inherit src unstable_typstPackages; });

      # Compile a Typst project, and then copy the result
      # to the current directory
      build-script = typixLib.buildTypstProjectLocal (
        commonArgs // { inherit src unstable_typstPackages; }
      );

      # Watch a project and recompile on changes
      watch-script = typixLib.watchTypstProject commonArgs;
    in
    {
      checks = { inherit build-drv build-script watch-script; };

      packages.default = build-drv;

      apps = rec {
        default = watch;
        build = inputs.flake-utils.lib.mkApp { drv = build-script; };
        watch = inputs.flake-utils.lib.mkApp { drv = watch-script; };
      };

      devShells.default = typixLib.devShell {
        shellHook = ''
          ${config.pre-commit.settings.shellHook}
        '';

        inherit (commonArgs) fontPaths virtualPaths;
        packages = [
          # WARNING: Don't run `typst-build` directly, instead use `nix run .#build`
          # See https://github.com/loqusion/typix/issues/2
          # build-script
          watch-script
          pkgs.just
        ];
      };
    };
}
