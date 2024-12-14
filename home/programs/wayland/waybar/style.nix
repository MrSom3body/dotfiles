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

        .module {
          color: @base05;
          background: transparent;
          border-radius: 15px;

          padding: 0.2em 0.5em;
          margin: 0.4em 0.2em;
        }

        .modules-left:first-child {
          margin-left: 0.2em;
        }

        .modules-right:last-child {
          margin-right: 0.2em;
        }

        tooltip {
          background: @base00;
          border: 3px solid @base0D;
          border-radius: ${rounding}px;
        }

        tooltip label {
          color: @base05;

          padding: 0.2em 0.5em;
        }

        #custom-actions {
          font-size: 1.3em;
          color: @base05;
          padding: 0.2rem 0.5rem;
        }

        #workspaces {
          background: @base01;
        }

        #workspaces button {
          color: @base05;
          border-radius: ${rounding}px;

          padding: 0.05em;
          margin: 0.2em 0.3em;
          transition: all 0.3s ease-in-out;
        }

        #workspace button:first-child {
          margin: 0.2em 0.3em 0.2em 0px;
        }

        #workspace button:last-child {
          margin: 0.2em 0px 0.2em 0.3em;
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
          border-radius: 15px;

          padding: 0.2em 0.5em;
          margin: 0.4em 0.2em;
        }

        #backlight {
          background: @base01;
        }

        #wireplumber {
          background: @base01;
        }

        #wireplumber.muted {
          color: @base00;
          background: @base0A;
        }

        #battery {
          background: @base01;
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

        #custom-monitor {
          background: @base01;
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
          padding: 0.25em;
          margin: 0.1em;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: @base0A;
        }

        #custom-swaync {
          background: @base01;
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
}
