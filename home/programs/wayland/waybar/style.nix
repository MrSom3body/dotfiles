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
        window#waybar {
          background: transparent;

          transition: all 0.3s ease-in-out;
        }

        tooltip {
          background: alpha(${base00}, ${builtins.toString config.stylix.opacity.desktop});

          border-radius: ${builtins.toString dotfiles.rounding}px;
          border: 3px solid ${base0D};
        }

        tooltip label {
          color: ${base05};
        }

        #clock {
          margin: 0 .25em 0 0;
          padding: .2em .5em;

          color: ${base05};
          background: ${base00};
          border-radius: ${builtins.toString dotfiles.rounding}px;
        }

        #window {
          margin: 0 .25em;
          padding: .2em .5em;

          color: ${base05};
          background: ${base00};
          border-radius: ${builtins.toString dotfiles.rounding}px;
        }

        window#waybar.empty #window {
          background: transparent;
        }

        #workspaces {
          transition: all 0.3s ease-in-out;
        }

        #workspaces button {
          margin: 0 .2em;
          padding: .2em .4em;

          color: ${base05};
          background: ${base00};
          min-width: 1.5em;

          border-radius: ${builtins.toString dotfiles.rounding}px;
          transition: all 0.3s ease-in-out;
        }

        #workspaces button.active {
          color: ${base00};
          background: ${base0D};

          min-width: 3em;
        }

        #workspaces button.special {
          color: ${base00};
          background: ${base0D};
        }

        #wireplumber {
          margin: 0 .25em;
          padding: .2em .5em;

          color: ${base00};
          background: ${base0C};
          border-radius: ${builtins.toString dotfiles.rounding}px;
        }

        #wireplumber {
          background: ${base0A};
        }

        #battery {
          margin: 0 .25em;
          padding: .2em .5em;

          color: ${base00};
          background: ${base0C};
          border-radius: ${builtins.toString dotfiles.rounding}px;
        }

        #battery.warning {
          color: ${base00};
          background: ${base0A};
        }


        #battery.charging, #battery.plugged {
          color: ${base00};
          background: ${base0B};
        }

        @keyframes blink {
          to {
            color: ${base05};
            background: ${base00};
          }
        }

        #battery.critical:not(.charging) {
          background-color: ${base08};
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #power-profiles-daemon {
          margin: 0 .25em;
          padding: .2em .5em;

          color: ${base00};
          border-radius: ${builtins.toString dotfiles.rounding}px;
        }

        #power-profiles-daemon.performance {
          background: ${base08};
        }

        #power-profiles-daemon.balanced {
          background: ${base0B};
        }

        #power-profiles-daemon.power-saver {
          background: ${base0D};
        }

        #idle_inhibitor {
          margin: 0 .25em;
          padding: .2em .5em;

          color: ${base05};
          background: ${base00};
          border-radius: ${builtins.toString dotfiles.rounding}px;
        }

        #idle_inhibitor.activated {
          color: ${base00};
          background: ${base09};
        }

        #custom-monitor,
        #cpu,
        #temperature,
        #memory {
          padding: .2em .5em;

          color: ${base05};
          background: ${base00};
        }

        #custom-monitor {
          margin: 0 .25em;

          border-radius: ${builtins.toString dotfiles.rounding}px;
        }

        #cpu {
          border-radius: ${builtins.toString dotfiles.rounding}px 0 0 ${builtins.toString dotfiles.rounding}px;
          margin: 0 0 0 .25em;
        }

        #temperature.critical {
          color: ${base08};
        }

        #memory {
          border-radius: 0 ${builtins.toString dotfiles.rounding}px ${builtins.toString dotfiles.rounding}px 0;
        }

        #tray {
          margin: 0 .25em;
          padding: .2em .5em;

          background: ${base00};
          border-radius: ${builtins.toString dotfiles.rounding}px;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: ${base0A};
        }

        #custom-notification {
          margin: 0 .25em;
          padding: .2em .5em;

          color: ${base05};
          background: ${base00};
          border-radius: ${builtins.toString dotfiles.rounding}px;
        }

        #custom-notification.notification,
        #custom-notification.dnd-notification,
        #custom-notification.inhibited-notification,
        #custom-notification.dnd-inhibited-notification {
          color: ${base00};
          background: ${base0A};
        }

        #custom-powermenu {
          margin: 0 0 0 .25em;
          padding: .2em .5em;

          color: ${base05};
          background: ${base00};
          border-radius: ${builtins.toString dotfiles.rounding}px;
        }
      '';
}