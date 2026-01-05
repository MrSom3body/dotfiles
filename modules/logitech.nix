{ lib, ... }:
{
  flake.modules = {
    nixos.logitech = {
      hardware.logitech.wireless.enable = true;
    };

    homeManager.logitech =
      { config, pkgs, ... }:
      {
        home.packages = [ pkgs.solaar ];
        home.file.".config/solaar/rules.yaml".text = ''
          ---
          - Key: [Screen Capture, pressed]
          - KeyPress:
            - Print
            - click
          ...
          ---
          - MouseGesture: Mouse Right
          - Execute: [hyprctl, dispatch, workspace, r+1]
          ...
          ---
          - MouseGesture: Mouse Left
          - Execute: [hyprctl, dispatch, workspace, r-1]
          ...
          ---
          - MouseGesture: Mouse Up
          - Execute: [hyprctl, dispatch, 'hyprexpo:expo', toggle]
          ...
        '';

        systemd.user.services.solaar = {
          Install.WantedBy = [ config.wayland.systemd.target ];

          Unit = {
            Description = "Linux devices manager for the Logitech Unifying Receiver";
            After = [ config.wayland.systemd.target ];
          };

          Service = {
            ExecStart = lib.concatStringsSep " " [
              "${pkgs.solaar}/bin/solaar"
              "--window"
              "hide"
              "--battery-icons"
              "regular"
              # "--restart-on-wake-up"
            ];
            Restart = "on-failure";
          };
        };

        wayland.windowManager.hyprland.settings.permissions = [
          "solaar-keyboard, keyboard, allow"
        ];
      };
  };
}
