{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.hypridle;
in {
  options.my.services.hypridle = {
    enable = mkEnableOption "the hypridle service";
  };

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;

      package = inputs.hypridle.packages.${pkgs.system}.hypridle;

      settings = let
        isLocked = command: "pgrep hyprlock && ${command}";
        isDischarging = command: "grep Discharging /sys/class/power_supply/BAT*/status -q && ${command}";
      in {
        general = {
          lock_cmd = "pgrep hyprlock || uwsm app -- hyprlock";
          unlock_cmd = "pkill -SIGUSR1 hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          inhibit_sleep = 3;
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
            on-timeout = "uwsm app -- hyprlock --grace 3";
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
            on-timeout = isDischarging "systemctl suspend";
          }
        ];
      };
    };

    systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
  };
}
