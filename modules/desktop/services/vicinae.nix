{ self, inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.vicinae-goodies ];

      programs.vicinae = {
        enable = true;
        systemd.enable = true;

        settings = {
          pop_to_root_on_close = true;
          close_on_focus_loss = false;
          search_files_in_root = true;

          providers = {
            # core
            "applications".preferences = {
              defaultAction = "launch";
              launchPrefix = "uwsm app --";
            };
            "clipboard".preferences = {
              eraseOnStartup = true;
              encryption = true;
            };
            "files".preferences = {
              excludedPaths = ".venv;.git;.direnv";
            };
            "power".entrypoints = {
              hibernate.preferences.confirm = false;
              logout.preferences.confirm = false;
              power-off.preferences.confirm = false;
              reboot.preferences.confirm = false;
              sleep.preferences.confirm = false;
              soft-reboot.preferences.confirm = false;
              suspend.preferences.confirm = false;
            };
            # plugins
            "@Gelei/bluetooth-0".preferences = {
              connectionToggleable = true;
            };
          };
        };

        extensions = builtins.attrValues {
          inherit (inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system})
            bluetooth
            nix
            wifi-commander
            # systemd # TODO doesn't build due to node-gyp see https://github.com/vicinaehq/extensions/blob/e01fe274f037e4d2b7436718258fa898f80dc4b2/flake.nix#L57
            ;
        };
      };
    };
}
