{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
        settings = {
          font-feature = [ "ss06" ];
          mouse-hide-while-typing = true;
          window-decoration = false;
          window-padding-balance = true;
          window-padding-x = 15;
          window-padding-y = 15;

          notify-on-command-finish = "unfocused";
          notify-on-command-finish-action = "notify,no-bell";
          notify-on-command-finish-after = "5s";

          quit-after-last-window-closed = true;
          quit-after-last-window-closed-delay = "5m";
        };
      };
    };
}
