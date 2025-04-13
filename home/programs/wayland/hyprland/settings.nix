{
  lib,
  config,
  settings,
  ...
}: {
  wayland.windowManager.hyprland.settings = let
    rgb = color: "rgb(${color})";
    cfg = config.wayland.windowManager.hyprland.settings;
  in {
    source = [
      "~/.config/hypr/monitors.conf"
      "~/.config/hypr/workspaces.conf"
    ];

    exec-once = [
      "uwsm finalize"
      "wpctl set-mute @DEFAULT_AUDIO_SINK@ 1"
      "uwsm app -- nm-applet"
      "uwsm app -- blueman-applet"

      # Applications
      "uwsm app -- solaar -w hide"
      "uwsm app -- rog-control-center"
      "uwsm app -- kdeconnect-indicator"
      "[workspace 1 silent] uwsm app -- ${settings.programs.browser}"
    ];

    general = {
      border_size = settings.appearance.border.size;
      gaps_in = 5;
      gaps_out = 10;
      layout = "dwindle";

      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      resize_on_border = false;

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = true;
    };

    decoration = {
      rounding = settings.appearance.border.radius;

      active_opacity = config.stylix.opacity.applications;
      inactive_opacity =
        lib.mkIf (config.stylix.opacity.applications < 1)
        (config.stylix.opacity.applications - 0.2);
      fullscreen_opacity = 1;

      shadow.range = 30;

      blur = {
        enabled = true;
        size = 4;
        passes = 2;
      };
    };

    input = {
      kb_layout = "at";
      kb_options = "eurosign:e,caps:swapescape";

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      follow_mouse = 1;

      scroll_method = "2fg";

      touchpad = {
        disable_while_typing = true;
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

    cursor = {
      no_hardware_cursors = false;
      use_cpu_buffer = true;
    };

    group = with config.lib.stylix.colors;
      lib.mkForce {
        "col.border_active" = rgb base0D;
        "col.border_inactive" = rgb base03;
        "col.border_locked_active" = rgb base0C;
        "col.border_locked_inactive" = rgb base0B;
        groupbar = let
          rounding = settings.appearance.border.radius;
        in {
          text_color = rgb base00;
          font_size = config.stylix.fonts.sizes.desktop;
          height = builtins.floor (config.stylix.fonts.sizes.desktop * 1.5 + 0.5);
          indicator_height = 0;
          inherit rounding;
          gradients = true;
          gradient_rounding = rounding;

          "col.active" = cfg.group."col.border_active";
          "col.inactive" = cfg.group."col.border_inactive";
          "col.locked_active" = cfg.group."col.border_locked_active";
          "col.locked_inactive" = cfg.group."col.border_locked_inactive";
        };
      };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      vfr = true;
      vrr = 1;
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
        bar_color = rgb config.lib.stylix.colors.base00;
        "col.text" = rgb config.lib.stylix.colors.base05;

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
