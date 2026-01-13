{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.vicinae = {
        enable = true;
        systemd.enable = true;

        settings = {
          pop_to_root_on_close = true;
          close_on_focus_loss = false;

          providers = {
            "clipboard".preferences = {
              eraseOnStartup = true;
            };
          };
        };

        extensions = builtins.attrValues {
          inherit (inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system})
            nix
            process-manager
            # systemd # TODO doesn't build due to node-gyp see https://github.com/vicinaehq/extensions/blob/e01fe274f037e4d2b7436718258fa898f80dc4b2/flake.nix#L57
            ;
        };
      };
    };
}
