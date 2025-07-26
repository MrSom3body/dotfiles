{
  lib,
  config,
  pkgs,
  settings,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.my.programs.waybar;
in
{
  config = mkIf cfg.enable {
    programs.waybar.style =
      let
        borderRadius = builtins.toString settings.appearance.border.radius;
        borderSize = builtins.toString settings.appearance.border.size;
      in
      # css
      ''
        * {
          padding: 0;
          margin: 0;
        }

        window#waybar {
          transition: all 0.3s ease-in-out;
        }

        .module {
          color: @base05;
          background: @base01;
          border-radius: ${borderRadius}px;

          padding: 0.2rem 0.5rem;
          margin: 0.4rem 0.2rem;
        }

        .modules-left:first-child {
          margin-left: 0.2em;
        }

        .modules-right:last-child {
          margin-right: 0.2em;
        }

        tooltip {
          background: @base00;
          border: ${borderSize}px solid @base0D;
          border-radius: ${borderRadius}px;
        }

        tooltip label {
          color: @base05;

          padding: 0.2rem 0.5rem;
        }

        window#waybar.battery-critical {
          background: mix(@base00, @base08, 0.3);
        }

        #custom-actions {
          color: @base0B;
          font-size: 1.3em;
        }

        #workspaces button {
          color: @base05;

          padding: 0.05rem;
          margin: 0.2rem 0.3rem;
          transition: all 0.3s ease-in-out;
        }

        #workspace button:first-child {
          margin: 0.2rem 0.3rem 0.2rem 0px;
        }

        #workspace button:last-child {
          margin: 0.2rem 0px 0.2rem 0.3rem;
        }

        #workspaces button.empty {
          color: @base03;
        }

        #workspaces button.visible {
          color: @base0E;
        }

        #workspaces button.active {
          color: @base0D;
        }

        #workspaces button.special {
          color: @base0C;
        }

        #workspaces button:hover {
          color: @base0B;
          background: transparent;
        }

        window#waybar.empty #window {
          background: transparent;
        }

        #systemd-failed-units {
          color: @base00;
          background: @base08;
        }

        #mpris {
          color: @base00;
          background: @base0C;
        }

        #mpris.paused {
          color: @base05;
          background: @base01;
        }

        #custom-hyprcast {
          color: @base00;
          background: @base08;

          animation-name: blink;
          animation-duration: 1s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #privacy {
          /* Because waybar does not set the module class */
          color: @base05;
          background: transparent;
          border-radius: ${borderRadius}px;

          padding: 0.2rem 0.5rem;
          margin: 0.4rem 0.2rem;
        }

        #wireplumber.muted {
          color: @base00;
          background: @base0A;
        }

        #battery.warning {
          color: @base00;
          background: @base0A;
        }

        #battery.charging,
        #battery.plugged {
          color: @base00;
          background: @base0B;
        }

        @keyframes blink {
          to {
            color: @base05;
            background: @base01;
          }
        }

        #battery.critical:not(.charging) {
          background-color: @base08;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #power-profiles-daemon {
          color: @base00;
        }

        #power-profiles-daemon.performance {
          background: @base08;
        }

        #power-profiles-daemon.balanced {
          background: @base0B;
        }

        #power-profiles-daemon.power-saver {
          background: @base0D;
        }

        #idle_inhibitor {
          background: @base02;
        }

        #idle_inhibitor.activated {
          color: @base00;
          background: @base09;
        }

        #disk,
        #cpu,
        #temperature,
        #memory {
          background: @base02;
        }

        #temperature.critical {
          color: @base08;
        }

        #tray {
          background: @base02;
        }

        #tray menu,
        #tray menuitem {
          padding: 0.25rem;
          margin: 0.1rem;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: @base0A;
        }

        #custom-fnott.dnd-on {
          color: @base00;
          background: @base0A;
        }

        #custom-swaync.dnd-notification,
        #custom-swaync.dnd-inhibited-notification {
          background: @base02;
        }

        #custom-swaync.notification,
        #custom-swaync.inhibited-notification {
          color: @base00;
          background: @base0A;
        }
      '';

    xdg.configFile."waybar/style.css" = {
      onChange = ''
        ${pkgs.procps}/bin/pkill -u $USER waybar || true
      '';
    };
  };
}
