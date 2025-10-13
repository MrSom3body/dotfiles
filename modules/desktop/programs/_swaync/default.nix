{ lib, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      services.swaync = {
        enable = true;
        settings = {
          positionX = "right";
          positionY = "top";
          layer = "overlay";
          control-center-layer = "overlay";
          control-center-exclusive-zone = true;
          layer-shell = true;
          cssPriority = "user";
          control-center-margin-top = 10;
          control-center-margin-bottom = 10;
          control-center-margin-right = 10;
          control-center-margin-left = 10;
          notification-2fa-action = true;
          notification-inline-replies = false;
          notification-icon-size = 64;
          notification-body-image-height = 100;
          notification-body-image-width = 200;
          timeout = 10;
          timeout-low = 5;
          timeout-critical = 0;
          fit-to-screen = true;
          relative-timestamps = true;
          control-center-width = 500;
          control-center-height = 600;
          notification-window-width = 500;
          keyboard-shortcuts = true;
          image-visibility = "when-available";
          transition-time = 200;
          hide-on-clear = false;
          hide-on-action = true;
          script-fail-notify = true;
          scripts = {
            example-script = {
              exec = "echo 'Do something...'";
              urgency = "Normal";
            };
            example-action-script = {
              exec = "echo 'Do something actionable!'";
              urgency = "Normal";
              run-on = "action";
            };
          };
          notification-visibility = {
            mute-spotify = {
              state = "transient";
              urgency = "Low";
              app-name = "Spotify";
            };
            mute-gpu-notifications = {
              state = "transient";
              app-name = "rog-control-center";
              body = "dGPU status changed:.*";
            };
          };
          widgets = [
            "inhibitors"
            "title"
            "buttons-grid"
            "notifications"
            "mpris"
            "volume"
            "backlight"
            "backlight#KB"
          ];
          widget-config = {
            inhibitors = {
              text = "Inhibitors";
              button-text = "Clear All";
              clear-all-button = true;
            };
            title = {
              text = "Notifications";
              clear-all-button = true;
              button-text = "Clear All";
            };
            mpris = {
              image-size = 96;
              image-radius = 12;
            };
            buttons-grid = {
              actions = [
                {
                  label = "";
                  type = "toggle";
                  active = true;
                  command = "fish -c 'test $SWAYNC_TOGGLE_STATE = true && nmcli radio wifi on || nmcli radio wifi off'";
                  update-command = "fish -c 'test $(nmcli radio wifi) = \"enabled\" && echo true || echo false'";
                }
                {
                  label = "";
                  type = "toggle";
                  active = true;
                  command = "fish -c 'test $SWAYNC_TOGGLE_STATE = true && bluetoothctl power on || bluetoothctl power off'";
                  update-command = "fish -c 'bluetoothctl show | rg \"PowerState: on\" -q && echo true || echo false'";
                }
                {
                  label = "󰖁";
                  type = "toggle";
                  active = false;
                  command = "fish -c 'test $SWAYNC_TOGGLE_STATE = true && wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 || wpctl set-mute @DEFAULT_AUDIO_SINK@ 0'";
                  update-command = "fish -c 'wpctl get-volume @DEFAULT_AUDIO_SINK@ | rg MUTED -q && echo true || echo false'";
                }
                {
                  label = "󰂛";
                  type = "toggle";
                  active = false;
                  command = "fish -c 'test $SWAYNC_TOGGLE_STATE = true && swaync-client --dnd-on || swaync-client --dnd-off'";
                  update-command = "fish -c 'swaync-client --get-dnd'";
                }
              ];
            };
            volume = {
              label = "󰕾";
              show-per-app = true;
              show-per-app-icon = true;
              show-per-app-label = true;
              expand-button-label = "";
              collapse-button-label = "";
            };
            backlight = {
              label = "";
              device = "amdgpu_bl1";
            };
            "backlight#backup" = {
              label = "";
              device = "amdgpu_bl2";
            };
            "backlight#KB" = {
              label = "";
              device = "asus::kbd_backlight";
              subsystem = "leds";
            };
          };
        };
      };

      home.activation.reloadSwaync = lib.hm.dag.entryAfter [ "installPackages" ] ''
        if ${lib.getExe' pkgs.procps "pgrep"} swaync > /dev/null; then
          ${lib.getExe' pkgs.swaynotificationcenter "swaync-client"} --reload-config --reload-css
        fi
      '';
    };
}
