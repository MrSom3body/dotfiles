{ self, lib, ... }:
{
  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    {
      programs.waybar = {
        enable = true;
        systemd.enable = true;

        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            spacing = 0;
            reload_style_on_change = true;

            modules-left = [
              "custom/actions"
              "systemd-failed-units"
              "hyprland/workspaces"
              "hyprland/window"
            ];

            modules-center = [
              "custom/update"
              "privacy"
              "clock"
              "mpris"
            ];

            modules-right = [
              "custom/hyprcast"
              "backlight"
              "wireplumber"
              "group/power"
              "group/hardware"
              "tray"
              "custom/fnott"
            ];

            "custom/actions" = {
              format = "";
              tooltip-format = "System Actions";
              on-click = "vicinae toggle";
            };

            "hyprland/workspaces" = {
              show-special = true;
              special-visible-only = true;
              format = "{icon}";

              format-icons = {
                "discord" = "";
                "todo" = "";
                "monitor" = "󰍹";
                "obsidian" = "";
                "spotify" = "";

                "default" = "";
                "1" = "1";
                "2" = "2";
                "3" = "3";
                "4" = "4";
                "5" = "5";
                "6" = "6";
                "7" = "7";
                "8" = "8";
                "9" = "9";
              };

              persistent-workspaces = {
                "*" = 5;
              };
            };

            "hyprland/window" = {
              max-length = 50;
              format = "{title}";
              icon = true;
            };

            systemd-failed-units =
              let
                fish = lib.getExe pkgs.fish;
                bat = lib.getExe pkgs.bat;
              in
              {
                format = "✗ {nr_failed}";
                on-click = "xdg-terminal-exec ${fish} -c \"${bat} --paging always -f (systemctl list-units --user --failed | psub -s -user-units) (systemctl list-units --failed | psub -s -system-units)\"";
                hide-on-ok = true;
              };

            "custom/update" = {
              exec = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.waybar-update;
              return-type = "json";
              hide-empty-text = true;
              interval = 60;
            };

            clock = {
              format = " {:%A %H:%M}";

              tooltip-format = "<tt><small>{calendar}</small></tt>";
              calendar = {
                mode = "month";
                weeks-pos = "left";
                mode-mon-col = 3;
                format =
                  let
                    colors = config.lib.stylix.colors.withHashtag;
                  in
                  {
                    months = "<span color='${colors.base06}'><b>{}</b></span>";
                    days = "<span color='${colors.base05}'><b>{}</b></span>";
                    weeks = "<span color='${colors.base0E}'><b>W{}</b></span>";
                    weekdays = "<span color='${colors.base0A}'><b>{}</b></span>";
                    today = "<span color='${colors.base0B}'><b><u>{}</u></b></span>";
                  };
              };

              actions = {
                on-click-right = "mode";
                on-click-middle = "shift_reset";
                on-scroll-up = "shift_up";
                on-scroll-down = "shift_down";
              };
            };

            mpris =
              let
                playerctl = lib.getExe config.services.playerctld.package;
              in
              {
                player = "spotify";
                format = "{player_icon} {status_icon} <b>{title}</b> by <i>{artist}</i>";
                tooltip-format = "Album: {album}";
                artist-len = 12;
                title-len = 22;
                ellipsis = "...";
                player-icons = {
                  default = "";
                  spotify = "󰓇";
                  kdeconnect = "";
                };
                status-icons = {
                  paused = "󰏤";
                };
                on-scroll-up = "${playerctl} volume 0.1+";
                on-scroll-down = "${playerctl} volume 0.1-";
              };

            "custom/hyprcast" =
              let
                hyprcast = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.hyprcast;
              in
              {
                exec = "${hyprcast} -w";
                return-type = "json";
                hide-empty-text = true;
                on-click = hyprcast;
                interval = "once";
                signal = 1;
              };

            backlight = {
              format = "{icon}";
              format-icons = [
                "󱩎"
                "󱩏"
                "󱩐"
                "󱩑"
                "󱩒"
                "󱩓"
                "󱩔"
                "󱩕"
                "󱩖"
                "󰛨"
              ];
              tooltip-format = "{percent}%";
            };

            wireplumber = {
              format = "{icon}";
              format-muted = "󰝟";
              format-icons = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
              tooltip-format = "{volume}% on {node_name}";
              on-click = lib.getExe pkgs.pwvucontrol;
              on-click-right = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
            };

            "group/power" = {
              orientation = "inherit";

              drawer = {
                transition-duration = 300;
                transition-left-to-right = false;
              };

              modules = [
                "battery"
                "idle_inhibitor"
                "power-profiles-daemon"
              ];
            };

            battery = {
              format = "{icon} {capacity}%";
              format-discharging = "{icon}";
              format-charging = "{icon}";
              format-plugged = "";
              format-icons = {
                charging = [
                  "󰢜"
                  "󰂆"
                  "󰂇"
                  "󰂈"
                  "󰢝"
                  "󰂉"
                  "󰢞"
                  "󰂊"
                  "󰂋"
                  "󰂅"
                ];
                default = [
                  "󰁺"
                  "󰁻"
                  "󰁼"
                  "󰁽"
                  "󰁾"
                  "󰁿"
                  "󰂀"
                  "󰂁"
                  "󰂂"
                  "󰁹"
                ];
              };
              format-full = "󰂅";
              tooltip-format-discharging = "{power:>1.2f}W↓ {capacity}%\n{timeTo}";
              tooltip-format-charging = "{power:>1.2f}W↑ {capacity}%\n{timeTo}";
              tooltip-format-plugged = "{capacity}%";

              interval = 5;
              states = {
                warning = 20;
                critical = 10;
              };
            };

            idle_inhibitor = {
              format = "{icon}";

              format-icons = {
                activated = "";
                deactivated = "";
              };
            };

            power-profiles-daemon = {
              format = "{icon}";
              tooltip-format = "Power profile: {profile}\nDriver: {driver}";
              tooltip = true;
              format-icons = {
                default = "";
                performance = "";
                balanced = "";
                power-saver = "";
              };
            };

            "group/hardware" = {
              orientation = "inherit";

              drawer = {
                transition-duration = 300;
                transition-left-to-right = false;
              };

              modules = [
                "custom/monitor"
                "disk"
                "cpu"
                "temperature"
                "memory"
              ];
            };

            "custom/monitor" = {
              format = "";
              tooltip = false;
              on-click = "hyprctl dispatch togglespecialworkspace monitor";
            };

            disk = {
              format = "󰋊 {percentage_free}%";
            };

            cpu = {
              format = " {usage}%";
              interval = 5;
            };

            temperature = {
              format = " {temperatureC}°C";
              interval = 5;
              critical-format = "󰸁 {temperatureC}°C";
              critical-threshold = 90;
            };

            memory = {
              format = " {used}/{total}GiB";
              interval = 5;
            };

            tray = {
              spacing = 5;
            };

            "custom/fnott" =
              let
                fnott-dnd = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.fnott-dnd;
              in
              {
                return-type = "json";
                exec = "${fnott-dnd} -w";
                interval = "once";
                signal = 2;

                on-click = "${lib.getExe' pkgs.fnott "fnottctl"} dismiss";
                on-click-right = fnott-dnd;
              };

            "custom/swaync" = {
              tooltip = false;
              format = "{} {icon}";

              format-icons = {
                notification = "󱅫";
                none = "󰂚";
                dnd-notification = "󰂛";
                dnd-none = "󰂛";
                inhibited-notification = "󰂛";
                inhibited-none = "󰂛";
                dnd-inhibited-notification = "󰂛";
                dnd-inhibited-none = "󰂛";
              };
              return-type = "json";
              exec-if = "which swaync-client";
              exec = "swaync-client -swb";
              on-click = "swaync-client -t -sw";
              on-click-middle = "swaync-client -C";
              on-click-right = "swaync-client -d -sw";
              escape = true;
            };
          };
        };
      };
    };
}
