{
  config,
  settings,
  ...
}: {
  services.swaync.style = let
    radius = builtins.toString settings.appearance.border.radius;
    border-size = builtins.toString settings.appearance.border.size;
  in
    with config.lib.stylix.colors.withHashtag; # css
    
      ''
        .notification-row {
          outline: none;
        }

        .notification-row:focus,
        .notification-row:hover {
          background: ${base01};
        }

        .notification-row .notification-background {
          padding: 6px 12px;
        }

        .notification-row .notification-background .close-button {
          /* The notification Close Button */
          background: ${base01};
          color: ${base05};
          text-shadow: none;
          padding: 0;
          border-radius: ${radius}px;
          margin-top: 5px;
          margin-right: 5px;
          box-shadow: none;
          border: none;
          min-width: 24px;
          min-height: 24px;
        }

        .notification-row .notification-background .close-button:hover {
          box-shadow: none;
          background: ${base02};
          transition: background 0.15s ease-in-out;
          border: none;
        }

        .notification-row .notification-background .notification {
          /* The actual notification */
          border-radius: ${radius}px;
          border: ${border-size}px solid ${base0D};
          padding: 0;
          transition: background 0.15s ease-in-out;
          background: ${base00};
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
          color: ${base05};
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
          background: ${base01};
        }

        .notification-row
          .notification-background
          .notification
          .notification-default-action {
          /* The large action that also displays the notification summary and body */
          border-radius: ${radius}px;
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
          border-radius: ${radius}px;
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
          color: ${base05};
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
          color: ${base03};
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
          color: ${base04};
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
          border-radius: ${radius}px;
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
          background: ${base00};
          color: ${base05};
          caret-color: ${base04};
          border: ${border-size}px solid ${base0D};
          border-radius: ${radius}px;
        }

        .notification-row
          .notification-background
          .notification
          .notification-default-action
          .notification-content
          .inline-reply
          .inline-reply-button {
          margin-left: 4px;
          background: ${base00};
          border: ${border-size}px solid ${base0D};
          border-radius: ${radius}px;
          color: ${base05};
        }

        .notification-row
          .notification-background
          .notification
          .notification-default-action
          .notification-content
          .inline-reply
          .inline-reply-button:disabled {
          background: ${base02};
          color: ${base03};
          border: ${border-size}px solid ${base0D};
          border-color: transparent;
        }

        .notification-row
          .notification-background
          .notification
          .notification-default-action
          .notification-content
          .inline-reply
          .inline-reply-button:hover {
          background: ${base02};
        }

        .notification-row .notification-background .notification .notification-action {
          /* The alternative actions below the default action */
          border-top: 3px solid ${base0D};
          border-radius: 0px;
          border-right: 3px solid ${base0D};
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
          color: ${base05};
        }

        .notification-group .notification-group-headers {
          /* Notification Group Headers */
        }

        .notification-group .notification-group-headers .notification-group-icon {
          color: ${base05};
        }

        .notification-group .notification-group-headers .notification-group-header {
          color: ${base05};
        }

        .notification-group .notification-group-buttons {
          /* Notification Group Buttons */
        }

        .notification-group.collapsed .notification-row .notification {
          background-color: ${base00};
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
          background-color: ${base02};
        }

        .control-center {
          /* The Control Center which contains the old notifications + widgets */
          background: ${base00};
          color: ${base05};
          border-radius: ${radius}px;
          border: ${border-size}px solid ${base0D};
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
          background-color: ${base02};
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
          color: ${base05};
          margin: 8px;
          font-size: 1.5rem;
        }

        .widget-title > button {
          font-size: initial;
          color: ${base05};
          text-shadow: none;
          background: ${base00};
          /* border: 3px solid ${base0D}; */
          border: none;
          box-shadow: none;
          border-radius: ${radius}px;
        }

        .widget-title > button:hover {
          background: ${base02};
        }

        /* DND widget */
        .widget-dnd {
          color: ${base05};
          margin: 8px;
          font-size: 1.1rem;
        }

        .widget-dnd > switch {
          font-size: initial;
          border-radius: ${radius}px;
          background: ${base00};
          border: ${border-size}px solid ${base0D};
          box-shadow: none;
        }

        .widget-dnd > switch:checked {
          background: ${base0E};
        }

        .widget-dnd > switch slider {
          background: ${base00};
          border-radius: ${radius}px;
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
          border-radius: ${radius}px;
          box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.75);
        }

        .widget-mpris .widget-mpris-player button:hover {
          /* The media player buttons (play, pause, next, etc...) */
          background: ${base02};
        }

        .widget-mpris .widget-mpris-player .widget-mpris-album-art {
          border-radius: ${radius}px;
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
          border-radius: ${radius}px;
          background-color: ${base01};
        }

        .widget-buttons-grid > flowbox > flowboxchild > button {
          color: ${base05};
          background: ${base00};
          border-radius: ${radius}px;
          transition: all 0.3s ease-in-out;
        }

        .widget-buttons-grid > flowbox > flowboxchild > button.toggle:hover {
          color: ${base00};
          background: shade(${base0B}, 0.7);
        }

        .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked {
          /* style given to the active toggle button */
          color: ${base00};
          background: ${base0B};
        }

        .widget-buttons-grid > flowbox > flowboxchild > button.toggle:checked:hover {
          color: ${base00};
          background: shade(${base08}, 0.7);
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
          border-radius: ${radius}px;
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
          background-color: ${base01};
          padding: 8px;
          margin: 8px 8px 0 8px;
          border-radius: ${radius}px ${radius}px 0 0;
        }

        .widget-volume > box > button {
          background: transparent;
          border: none;
          border-radius: ${radius}px;
        }

        .per-app-volume {
          background-color: ${base01};
          padding: 4px 8px 8px 8px;
          margin: 0 8px 8px 8px;
          border-radius: ${radius}px;
        }

        /* Backlight widget */
        .widget-backlight {
          background-color: ${base01};
          padding: 8px;
          margin: 0 8px 0 8px;
          border-radius: 0;
        }

        .widget-backlight.KB {
          border-radius: 0 0 ${radius}px ${radius}px;
          margin: 0 8px 8px 8px;
        }

        /* Inhibitors widget */
        .widget-inhibitors {
          margin: 8px;
          font-size: 1.5rem;
        }

        .widget-inhibitors > button {
          font-size: initial;
          color: ${base05};
          text-shadow: none;
          background: ${base00};
          border: ${border-size}px solid ${base0D};
          box-shadow: none;
          border-radius: ${radius}px;
        }

        .widget-inhibitors > button:hover {
          background: ${base02};
        }
      '';
}
