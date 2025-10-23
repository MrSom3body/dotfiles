{
  perSystem =
    { config, pkgs, ... }:
    {
      default = pkgs.mkShell {
        packages = with pkgs; [
          git
        ];

        buildInputs = [ ];

        shellHook = ''
          ${config.pre-commit.settings.shellHook}
        '';
      };
    };
}
