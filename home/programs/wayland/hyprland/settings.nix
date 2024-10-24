{
  config,
  dotfiles,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    source = [
      "~/.config/hypr/monitors.conf"
      "~/.config/hypr/workspaces.conf"
    ];

    exec-once = [
      "wpctl set-mute @DEFAULT_AUDIO_SINK@ 1"
      "waybar"
      "cliphist wipe"
      "nm-applet"
      "blueman-applet"

      # Applications
      "solaar -w hide"
      "rog-control-center"
      "kdeconnectd & kdeconnect-indicator"
      "signal"
      "[workspace 1 silent] ${dotfiles.browser}"
    ];

    general = {
      border_size = 3;
      gaps_in = 5;
      gaps_out = 10;
      layout = "dwindle";

      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      resize_on_border = false;

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = true;
    };

    decoration = {
      inherit (dotfiles) rounding;

      # active_opacity = config.stylix.opacity.applications;
      # inactive_opacity = 0.75;
      fullscreen_opacity = 1;

      drop_shadow = true;
      shadow_range = 30;

      blur = {
        enabled = true;
        size = 6;
        passes = 2;
        ignore_opacity = true;
        xray = false;
        special = false;
      };
    };

    input = {
      kb_layout = "at";
      # kb_options = "eurosign:e";

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      follow_mouse = 1;

      scroll_method = "2fg";

      touchpad = {
        disable_while_typing = false;
        natural_scroll = true;
        tap_button_map = "lrm";
        tap-to-click = true;
        tap-and-drag = true;
      };
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
      workspace_swipe_create_new = true;
      workspace_swipe_direction_lock = false;
      workspace_swipe_forever = true;
      workspace_swipe_use_r = true;
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      new_status = "master";
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      vfr = true;
      vrr = 1;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
      animate_manual_resizes = true;
      focus_on_activate = true;
    };

    plugin = {
      hyprbars = {
        bar_height = config.stylix.fonts.sizes.desktop * 2;
        bar_button_padding = config.stylix.fonts.sizes.desktop / 2;

        bar_part_of_window = true;
        bar_precedence_over_border = true;

        bar_text_size = config.stylix.fonts.sizes.desktop;
        bar_color = "rgb(${config.lib.stylix.colors.base00})";
        "col.text" = "rgb(${config.lib.stylix.colors.base05})";

        hyprbars-button = let
          buttonSize = builtins.toString (config.stylix.fonts.sizes.desktop * 1.5);
        in [
          "rgb(${config.lib.stylix.colors.base08}), ${buttonSize}, 󰖭, hyprctl dispatch killactive"
          "rgb(${config.lib.stylix.colors.base0B}), ${buttonSize}, 󰖯, hyprctl dispatch fullscreen 1"
        ];
      };
    };
  };
}
