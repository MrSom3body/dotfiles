{
  config,
  lib,
  pkgs,
  dotfiles,
  ...
}: {
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
        # mute-spotify = {
        #   state = "muted";
        #   urgency = "Low";
        #   app-name = "Spotify";
        # };
        mute-gpu-notifications = {
          state = "transient";
          app-name = "ROG Control";
          summary = "dGPU status changed: .*";
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
              update-command = "fish -c 'test $(swaync-client --get-dnd) = \"true\" && echo true || echo false'";
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
        "backlight#KB" = {
          label = "";
          device = "asus::kbd_backlight";
          subsystem = "leds";
        };
      };
    };
    style = ''
      .notification-row {
        outline: none;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: ${config.lib.stylix.colors.withHashtag.base01};
      }

      .notification-row .notification-background {
        padding: 6px 12px;
      }

      .notification-row .notification-background .close-button {
        /* The notification Close Button */
        background: ${config.lib.stylix.colors.withHashtag.base01};
        color: ${config.lib.stylix.colors.withHashtag.base05};
        text-shadow: none;
        padding: 0;
        border-radius: ${builtins.toString dotfiles.rounding}px;
        margin-top: 5px;
        margin-right: 5px;
        box-shadow: none;
        border: none;
        min-width: 24px;
        min-height: 24px;
      }

      .notification-row .notification-background .close-button:hover {
        box-shadow: none;
        background: ${config.lib.stylix.colors.withHashtag.base02};
        transition: background 0.15s ease-in-out;
        border: none;
      }

      .notification-row .notification-background .notification {
        /* The actual notification */
        border-radius: ${builtins.toString dotfiles.rounding}px;
        border: 3px solid ${config.lib.stylix.colors.withHashtag.base0D};
        padding: 0;
        transition: background 0.15s ease-in-out;
        background: ${config.lib.stylix.colors.withHashtag.base00};
      }

      .notification-row .notification-background .notification.low {
        /* Low Priority Notification */
      }

      .notification-row .notification-background .notification.normal {
        /* Normal Priority Notification */
      }

      .notification-row .notification-background .notification.critical {
        /* Critical Priority Notification */
      }

      .notification-row .notification-background .notification .notification-action,
      .notification-row
        .notification-background
        .notification
        .notification-default-action {
        padding: 4px;
        margin: 0;
        box-shadow: none;
        background: transparent;
        border: none;
        color: ${config.lib.stylix.colors.withHashtag.base05};
        transition: background 0.15s ease-in-out;
      }

      .notification-row
        .notification-background
        .notification
        .notification-action:hover,
      .notification-row
        .notification-background
        .notification
        .notification-default-action:hover {
        -gtk-icon-effect: none;
        background: ${config.lib.stylix.colors.withHashtag.base01};
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action {
        /* The large action that also displays the notification summary and body */
        border-radius: ${builtins.toString dotfiles.rounding}px;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action:not(:only-child) {
        /* When alternative actions are visible */
        border-bottom-left-radius: 0px;
        border-bottom-right-radius: 0px;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content {
        background: transparent;
        border-radius: ${builtins.toString dotfiles.rounding}px;
        padding: 4px;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content
        .image {
        /* Notification Primary Image */
        -gtk-icon-effect: none;
        border-radius: 100px;
        /* Size in px */
        margin: 4px;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content
        .app-icon {
        /* Notification app icon (only visible when the primary image is set) */
        -gtk-icon-effect: none;
        -gtk-icon-shadow: 0 1px 4px black;
        margin: 6px;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content
        .text-box
        .summary {
        /* Notification summary/title */
        font-size: 16px;
        font-weight: bold;
        background: transparent;
        color: ${config.lib.stylix.colors.withHashtag.base05};
        text-shadow: none;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content
        .text-box
        .time {
        /* Notification time-ago */
        font-size: 16px;
        font-weight: bold;
        background: transparent;
        color: ${config.lib.stylix.colors.withHashtag.base03};
        text-shadow: none;
        margin-right: 30px;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content
        .text-box
        .body {
        /* Notification body */
        font-size: 15px;
        font-weight: normal;
        background: transparent;
        color: ${config.lib.stylix.colors.withHashtag.base04};
        text-shadow: none;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content
        progressbar {
        /* The optional notification progress bar */
        margin-top: 4px;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content
        .body-image {
        /* The "extra" optional bottom notification image */
        margin-top: 4px;
        background-color: white;
        border-radius: ${builtins.toString dotfiles.rounding}px;
        -gtk-icon-effect: none;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content
        .inline-reply {
        /* The inline reply section */
        margin-top: 4px;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content
        .inline-reply
        .inline-reply-entry {
        background: ${config.lib.stylix.colors.withHashtag.base00};
        color: ${config.lib.stylix.colors.withHashtag.base05};
        caret-color: ${config.lib.stylix.colors.withHashtag.base04};
        border: 3px solid ${config.lib.stylix.colors.withHashtag.base0D};
        border-radius: ${builtins.toString dotfiles.rounding}px;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content
        .inline-reply
        .inline-reply-button {
        margin-left: 4px;
        background: ${config.lib.stylix.colors.withHashtag.base00};
        border: 3px solid ${config.lib.stylix.colors.withHashtag.base0D};
        border-radius: ${builtins.toString dotfiles.rounding}px;
        color: ${config.lib.stylix.colors.withHashtag.base05};
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content
        .inline-reply
        .inline-reply-button:disabled {
        background: ${config.lib.stylix.colors.withHashtag.base02};
        color: ${config.lib.stylix.colors.withHashtag.base03};
        border: 3px solid ${config.lib.stylix.colors.withHashtag.base0D};
        border-color: transparent;
      }

      .notification-row
        .notification-background
        .notification
        .notification-default-action
        .notification-content
        .inline-reply
        .inline-reply-button:hover {
        background: ${config.lib.stylix.colors.withHashtag.base02};
      }

      .notification-row .notification-background .notification .notification-action {
        /* The alternative actions below the default action */
        border-top: 3px solid ${config.lib.stylix.colors.withHashtag.base0D};
        border-radius: 0px;
        border-right: 3px solid ${config.lib.stylix.colors.withHashtag.base0D};
      }

      .notification-row
        .notification-background
        .notification
        .notification-action:first-child {
        /* add bottom border radius to eliminate clipping */
        border-bottom-left-radius: 12px;
      }

      .notification-row
        .notification-background
        .notification
        .notification-action:last-child {
        border-bottom-right-radius: 12px;
        border-right: none;
      }

      .notification-group {
        /* Styling only for Grouped Notifications */
      }

      .notification-group.low {
        /* Low Priority Group */
      }

      .notification-group.normal {
        /* Low Priority Group */
      }

      .notification-group.critical {
        /* Low Priority Group */
      }

      .notification-group .notification-group-buttons,
      .notification-group .notification-group-headers {
        margin: 0 16px;
        color: ${config.lib.stylix.colors.withHashtag.base05};
      }

      .notification-group .notification-group-headers {
        /* Notification Group Headers */
      }

      .notification-group .notification-group-headers .notification-group-icon {
        color: ${config.lib.stylix.colors.withHashtag.base05};
      }

      .notification-group .notification-group-headers .notification-group-header {
        color: ${config.lib.stylix.colors.withHashtag.base05};
      }

      .notification-group .notification-group-buttons {
        /* Notification Group Buttons */
      }

      .notification-group.collapsed .notification-row .notification {
        background-color: ${config.lib.stylix.colors.withHashtag.base00};
      }

      .notification-group.collapsed .notification-row:not(:last-child) {
        /* Top notification in stack */
        /* Set lower stacked notifications opacity to 0 */
      }

      .notification-group.collapsed
        .notification-row:not(:last-child)
        .notification-action,
      .notification-group.collapsed
        .notification-row:not(:last-child)
        .notification-default-action {
        opacity: 0;
      }

      .notification-group.collapsed:hover
        .notification-row:not(:only-child)
        .notification {
        background-color: ${config.lib.stylix.colors.withHashtag.base02};
      }

      .control-center {
        /* The Control Center which contains the old notifications + widgets */
        background: ${config.lib.stylix.colors.withHashtag.base00};
        color: ${config.lib.stylix.colors.withHashtag.base05};
        border-radius: ${builtins.toString dotfiles.rounding}px;
        border: 3px solid ${config.lib.stylix.colors.withHashtag.base0D};
      }

      .control-center .control-center-list-placeholder {
        /* The placeholder when there are no notifications */
        opacity: 0.5;
      }

      .control-center .control-center-list {
        /* List of notifications */
        background: transparent;
      }

      .control-center .control-center-list .notification {
        box-shadow:
          0 0 0 1px rgba(0, 0, 0, 0.3),
          0 1px 3px 1px rgba(0, 0, 0, 0.7),
          0 2px 6px 2px rgba(0, 0, 0, 0.3);
      }

      .control-center .control-center-list .notification .notification-default-action,
      .control-center .control-center-list .notification .notification-action {
        transition:
          opacity 400ms ease-in-out,
          background 0.15s ease-in-out;
      }

      .control-center
        .control-center-list
        .notification
        .notification-default-action:hover,
      .control-center .control-center-list .notification .notification-action:hover {
        background-color: ${config.lib.stylix.colors.withHashtag.base02};
      }

      .blank-window {
        /* Window behind control center and on all other monitors */
        background: transparent;
      }

      .floating-notifications {
        background: transparent;
      }

      .floating-notifications .notification {
        box-shadow: none;
      }

      /*** Widgets ***/
      /* Title widget */
      .widget-title {
        color: ${config.lib.stylix.colors.withHashtag.base05};
        margin: 8px;
        font-size: 1.5rem;
      }

      .widget-title > button {
        font-size: initial;
        color: ${config.lib.stylix.colors.withHashtag.base05};
        text-shadow: none;
        background: ${config.lib.stylix.colors.withHashtag.base00};
        /* border: 3px solid ${config.lib.stylix.colors.withHashtag.base0D}; */
        border: none;
        box-shadow: none;
        border-radius: ${builtins.toString dotfiles.rounding}px;
      }

      .widget-title > button:hover {
        background: ${config.lib.stylix.colors.withHashtag.base02};
      }

      /* DND widget */
      .widget-dnd {
        color: ${config.lib.stylix.colors.withHashtag.base05};
        margin: 8px;
        font-size: 1.1rem;
      }

      .widget-dnd > switch {
        font-size: initial;
        border-radius: ${builtins.toString dotfiles.rounding}px;
        background: ${config.lib.stylix.colors.withHashtag.base00};
        border: 3px solid ${config.lib.stylix.colors.withHashtag.base0D};
        box-shadow: none;
      }

      .widget-dnd > switch:checked {
        background: ${config.lib.stylix.colors.withHashtag.base0E};
      }

      .widget-dnd > switch slider {
        background: ${config.lib.stylix.colors.withHashtag.base00};
        border-radius: ${builtins.toString dotfiles.rounding}px;
      }

      /* Label widget */
      .widget-label {
        margin: 8px;
      }

      .widget-label > label {
        font-size: 1.1rem;
      }

      /* Mpris widget */
      @define-color mpris-album-art-overlay rgba(0, 0, 0, 0.55);
      @define-color mpris-button-hover rgba(0, 0, 0, 0.50);
      .widget-mpris {
        /* The parent to all players */
      }

      .widget-mpris .widget-mpris-player {
        padding: 8px;
        padding: 16px;
        margin: 16px 20px;
        background-color: @mpris-album-art-overlay;
        border-radius: ${builtins.toString dotfiles.rounding}px;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.75);
      }

      .widget-mpris .widget-mpris-player button:hover {
        /* The media player buttons (play, pause, next, etc...) */
        background: ${config.lib.stylix.colors.withHashtag.base02};
      }

      .widget-mpris .widget-mpris-player .widget-mpris-album-art {
        border-radius: ${builtins.toString dotfiles.rounding}px;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.75);
      }

      .widget-mpris .widget-mpris-player .widget-mpris-title {
        font-weight: bold;
        font-size: 1.25rem;
      }

      .widget-mpris .widget-mpris-player .widget-mpris-subtitle {
        font-size: 1.1rem;
      }

      .widget-mpris .widget-mpris-player > box > button {
        /* Change player control buttons */
      }

      .widget-mpris .widget-mpris-player > box > button:hover {
        background-color: @mpris-button-hover;
      }

      .widget-mpris > box > button {
        /* Change player side buttons */
      }

      .widget-mpris > box > button:disabled {
        /* Change player side buttons insensitive */
      }

      /* Buttons widget */
      .widget-buttons-grid {
        padding: 8px;
        margin: 8px;
        border-radius: ${builtins.toString dotfiles.rounding}px;
        background-color: ${config.lib.stylix.colors.withHashtag.base01};
      }

      .widget-buttons-grid > flowbox > flowboxchild > button {
        color: ${config.lib.stylix.colors.withHashtag.base05};
        background: ${config.lib.stylix.colors.withHashtag.base00};
        border-radius: ${builtins.toString dotfiles.rounding}px;
        transition: all 0.3s ease-in-out;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button.toggle:hover {
        color: ${config.lib.stylix.colors.withHashtag.base00};
        background: shade(${config.lib.stylix.colors.withHashtag.base0B}, 0.7);
      }

      .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked {
        /* style given to the active toggle button */
        color: ${config.lib.stylix.colors.withHashtag.base00};
        background: ${config.lib.stylix.colors.withHashtag.base0B};
      }

      .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked:hover {
        color: ${config.lib.stylix.colors.withHashtag.base00};
        background: shade(${config.lib.stylix.colors.withHashtag.base08}, 0.7);
      }

      /* Menubar widget */
      .widget-menubar > box > .menu-button-bar > button {
        border: none;
        background: transparent;
      }

      /* .AnyName { Name defined in config after #
        background-color: @background;
        padding: 8px;
        margin: 8px;
        border-radius: ${builtins.toString dotfiles.rounding}px;
      }

      .AnyName>button {
        background: transparent;
        border: none;
      }

      .AnyName>button:hover {
        background-color: @color0;
      } */

      .topbar-buttons > button {
        /* Name defined in config after # */
        border: none;
        background: transparent;
      }

      /* Volume widget */
      .widget-volume {
        background-color: ${config.lib.stylix.colors.withHashtag.base01};
        padding: 8px;
        margin: 8px 8px 0 8px;
        border-radius: ${builtins.toString dotfiles.rounding}px ${builtins.toString dotfiles.rounding}px 0 0;
      }

      .widget-volume > box > button {
        background: transparent;
        border: none;
        border-radius: ${builtins.toString dotfiles.rounding}px;
      }

      .per-app-volume {
        background-color: ${config.lib.stylix.colors.withHashtag.base01};
        padding: 4px 8px 8px 8px;
        margin: 0 8px 8px 8px;
        border-radius: ${builtins.toString dotfiles.rounding}px;
      }

      /* Backlight widget */
      .widget-backlight {
        background-color: ${config.lib.stylix.colors.withHashtag.base01};
        padding: 8px;
        margin: 0 8px 0 8px;
        border-radius: 0;
      }

      .widget-backlight.KB {
        border-radius: 0 0 ${builtins.toString dotfiles.rounding}px ${builtins.toString dotfiles.rounding}px;
        margin: 0 8px 8px 8px;
      }

      /* Inhibitors widget */
      .widget-inhibitors {
        margin: 8px;
        font-size: 1.5rem;
      }

      .widget-inhibitors > button {
        font-size: initial;
        color: ${config.lib.stylix.colors.withHashtag.base05};
        text-shadow: none;
        background: ${config.lib.stylix.colors.withHashtag.base00};
        border: 3px solid ${config.lib.stylix.colors.withHashtag.base0D};
        box-shadow: none;
        border-radius: ${builtins.toString dotfiles.rounding}px;
      }

      .widget-inhibitors > button:hover {
        background: ${config.lib.stylix.colors.withHashtag.base02};
      }
    '';
  };

  home.activation.reloadSwaync = lib.hm.dag.entryAfter ["installPackages"] ''
    if ${lib.getExe' pkgs.procps "pgrep"} swaync > /dev/null; then
      ${lib.getExe' pkgs.swaynotificationcenter "swaync-client"} --reload-css
    fi
  '';
}
