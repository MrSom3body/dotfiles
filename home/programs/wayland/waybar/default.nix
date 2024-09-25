{
  pkgs,
  lib,
  config,
  ...
}
: {
  imports = [./style.nix];

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin = "10 10 0 10";
        reload_style_on_change = true;

        modules-left = [
          "clock"
          "hyprland/window"
        ];

        modules-center = ["hyprland/workspaces"];

        modules-right = [
          "privacy"
          "wireplumber"
          "group/power"
          "group/hardware"
          "tray"
          "custom/notification"
          "custom/powermenu"
        ];

        "clock" = {
          format = "  {:%H:%M}";
          tooltip-format = "  {:%a, %d %b}";
          # tooltip-format="<tt><small>{calendar}</small></tt>";

          calendar = {
            mode = "month";
            weeks-pos = "left";
            mode-mon-col = 3;
            format = with config.lib.stylix.colors.withHashtag; {
              months = "<span color='${base06}'><b>{}</b></span>";
              days = "<span color='${base05}'><b>{}</b></span>";
              weeks = "<span color='${base0E}'><b>W{}</b></span>";
              weekdays = "<span color='${base0A}'><b>{}</b></span>";
              today = "<span color='${base0B}'><b><u>{}</u></b></span>";
            };
          };

          actions = {
            on-click = "shift_reset";
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "hyprland/workspaces" = {
          show-special = true;
          special-visible-only = true;
          format = "{icon}";

          format-icons = {
            "spotify" = "";
            "discord" = "";
            "monitor" = "󰍹";
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

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "󱐋  {capacity}%";
          format-plugged = "  {capacity}%";
          format-alt = "{icon}  {time}";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
        };

        "idle_inhibitor" = {
          format = "{icon}";

          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };

        "power-profiles-daemon" = {
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

        "wireplumber" = {
          format = "{icon}  {volume}%";
          format-muted = "󰝟";
          on-click = "pwvucontrol";
          format-icons = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
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

        "custom/monitor" = {
          format = "";
          tooltip = false;
          on-click = "hyprctl dispatch workspace special:monitor";
        };

        "cpu" = {
          format = "  {usage}%";
        };

        "temperature" = {
          format = "  {temperatureC}°C";
          critical-format = "󰸁 {temperatureC}°C";
          critical-threshold = 90;
        };

        "memory" = {
          format = "  {used}/{total}GiB";
        };

        "group/hardware" = {
          orientation = "inherit";

          drawer = {
            transition-duration = 300;
            transition-left-to-right = false;
          };

          modules = [
            "custom/monitor"
            "cpu"
            "temperature"
            "memory"
          ];
        };

        "tray" = {
          spacing = 5;
        };

        "custom/notification" = {
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

        "custom/powermenu" = {
          format = "";
          on-click = "rofi -show powermenu -modes powermenu";
        };
      };
    };
  };

  home.activation.restartWaybar = lib.hm.dag.entryAfter ["installPackages"] ''
    if ${lib.getExe' pkgs.procps "pgrep"} waybar > /dev/null; then
      ${lib.getExe' pkgs.procps "pkill"} -SIGUSR2 waybar
    fi '';

  home.file.".config/waybar/scripts" = {
    source = ./scripts;
    executable = true;
  };
}
