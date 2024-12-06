{
  config,
  dotfiles,
  ...
}: {
  programs.waybar.style = let
    rounding = builtins.toString dotfiles.rounding;
  in
    with config.lib.stylix.colors.withHashtag; # css
    
      ''
        @define-color base00 ${base00};
        @define-color base01 ${base01};
        @define-color base02 ${base02};
        @define-color base03 ${base03};
        @define-color base04 ${base04};
        @define-color base05 ${base05};
        @define-color base06 ${base06};
        @define-color base07 ${base07};
        @define-color base08 ${base08};
        @define-color base09 ${base09};
        @define-color base0A ${base0A};
        @define-color base0B ${base0B};
        @define-color base0C ${base0C};
        @define-color base0D ${base0D};
        @define-color base0E ${base0E};
        @define-color base0F ${base0F};

        * {
          padding: 0;
          margin: 0;
        }

        window#waybar {
          background: alpha(@base00, ${builtins.toString (config.stylix.opacity.desktop - 0.02)});
          transition: all 0.3s ease-in-out;
        }

        tooltip {
          background: @base00;
          border: 3px solid @base0D;
          border-radius: ${rounding};
        }

        tooltip label {
          color: @base05;

          padding: 0.2em 0.5em;
        }

        #workspaces {
          background: @base01;
          border-radius: ${rounding};

          padding: 0.05em;
          margin: 0.4em 0.2em 0.4em 0.4em;
        }

        #workspaces button {
          color: @base05;
          border-radius: ${rounding};

          padding: 0.05em;
          margin: 0.2em 0.3em;
          transition: all 0.3s ease-in-out;
        }

        #workspaces button.active {
          color: @base00;
          background: @base0D;

          min-width: 3em;
        }

        #workspaces button.special {
          color: @base00;
          background: @base0D;
        }

        window#waybar.empty #window {
          background: transparent;
        }

        #window {
          background: transparent;
          border-radius: ${rounding};

          padding: 0.2em 0.5em;
          margin: 0.4em 0.2em;
        }

        #clock {
          background: transparent;
          border-radius: ${rounding};

          padding: 0.2em 0.5em;
          margin: 0.4em;
        }

        #custom-hyprcast {
          margin: 0 0.25em;
          padding: 0.2em 0.5em;

          color: @base00;
          background: @base08;
          border-radius: ${rounding};

          animation-name: blink;
          animation-duration: 1s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #wireplumber {
          color: @base05;
          background: @base01;
          border-radius: ${rounding};

          padding: 0.2em 0.5em;
          margin: 0.4em 0.2em;
        }

        #wireplumber.muted {
          color: @base00;
          background: @base0A;
        }

        #battery {
          color: @base05;
          background: @base01;
          border-radius: ${rounding};

          padding: 0.2em 0.5em;
          margin: 0.4em 0.2em;
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
          border-radius: ${rounding};

          padding: 0 0.6em;
          margin: 0.4em 0.2em;
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
          color: @base05;
          background: @base01;
          border-radius: ${rounding};

          padding: 0 0.6em;
          margin: 0.4em 0.2em;
        }

        #idle_inhibitor.activated {
          color: @base00;
          background: @base09;
        }

        #custom-monitor,
        #cpu,
        #temperature,
        #memory {
          color: @base05;
          background: @base01;
          border-radius: ${rounding};

          padding: 0 0.6em;
          margin: 0.4em 0.2em;
        }

        #cpu,
        #temperature,
        #memory {
          background: @base01;
        }

        #temperature.critical {
          color: @base08;
        }

        #tray {
          color: @base05;
          background: @base01;
          border-radius: ${rounding};

          padding: 0 0.6em;
          margin: 0.4em 0.2em;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: @base0A;
        }

        #custom-notification {
          color: @base05;
          background: transparent;
          border-radius: ${rounding};

          padding: 0 0.6em;
          margin: 0.4em 0.2em;
        }

        #custom-notification.notification,
        #custom-notification.dnd-notification,
        #custom-notification.inhibited-notification,
        #custom-notification.dnd-inhibited-notification {
          color: @base00;
          background: @base0A;
        }

        #custom-powermenu {
          color: @base05;
          background: @base01;
          border-radius: ${rounding};

          padding: 0 0.6em;
          margin: 0.4em 0.2em 0.4em 0.2em;
        }
      '';
}
