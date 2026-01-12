{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      imports = [ inputs.vicinae.homeManagerModules.default ];

      services.vicinae = {
        enable = true;
        systemd.enable = true;

        settings = {
          pop_to_root_on_close = true;
          close_on_focus_loss = true;
        };

        extensions = builtins.attrValues {
          inherit (inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system})
            nix
            ;
        };
      };
    };
}
