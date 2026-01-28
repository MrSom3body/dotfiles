{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { config, ... }:
    {
      services.hypridle = {
        enable = true;

        settings =
          let
            isLocked = command: "pgrep hyprlock && ${command}";
            isDischarging = command: "grep Discharging /sys/class/power_supply/BAT*/status -q && ${command}";
          in
          {
            general = {
              lock_cmd = "pgrep hyprlock || uwsm app -- ${lib.getExe config.programs.hyprlock.package}";
              unlock_cmd = "pkill -SIGUSR1 hyprlock";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
            };

            listener = [
              {
                timeout = 10;
                on-timeout = "brightnessctl --save";
                on-resume = "brightnessctl --restore";
              }
              {
                timeout = 30;
                on-timeout = "brightnessctl --device *:kbd_backlight --save set 0";
                on-resume = "brightnessctl --device *:kbd_backlight --restore";
              }
              {
                timeout = 50;
                on-timeout = "brightnessctl set 50%-";
              }
              {
                timeout = 110;
                on-timeout = "brightnessctl set 50%-";
              }
              {
                timeout = 120;
                on-timeout = "pgrep hyprlock || uwsm app -- hyprlock --grace 3";
              }
              {
                timeout = 140;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }

              # If already locked
              {
                timeout = 15;
                on-timeout = isLocked "brightnessctl set 75%-";
              }
              {
                timeout = 20;
                on-timeout = isLocked "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }

              # If discharging
              {
                timeout = 600;
                on-timeout = isDischarging "systemctl suspend-then-hibernate";
              }
            ];
          };
      };

    };
}
