{
  lib,
  config,
  settings,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.my.desktop.hyprland;
  cfg' = config.wayland.windowManager.hyprland.settings;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings =
      let
        rgb = color: "rgb(${color})";
      in
      {
        monitor = cfg.monitors ++ [
          ", preferred, auto, auto"
        ];

        exec-once = [
          "wpctl set-mute @DEFAULT_AUDIO_SINK@ 1"
        ];

        general = {
          border_size = settings.appearance.border.size;
          gaps_in = 5;
          gaps_out = 10;
          inherit (cfg) layout;

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false;

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = true;
        };

        render.new_render_scheduling = true;

        decoration = {
          rounding = settings.appearance.border.radius;

          active_opacity = config.stylix.opacity.applications;
          inactive_opacity = lib.mkIf (config.stylix.opacity.applications < 1) (
            config.stylix.opacity.applications - 0.2
          );
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
          workspace_swipe_create_new = true;
          workspace_swipe_direction_lock = false;
          workspace_swipe_forever = true;
          workspace_swipe_use_r = true;
        };

        gesture = [
          "3, horizontal, workspace"
          "4, down, dispatcher, exec, loginctl lock-session"
        ];

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

        group =
          let
            inherit (config.lib.stylix) colors;
          in
          lib.mkForce {
            "col.border_active" = rgb colors.base0D;
            "col.border_inactive" = rgb colors.base03;
            "col.border_locked_active" = rgb colors.base0C;
            "col.border_locked_inactive" = rgb colors.base0B;
            groupbar =
              let
                rounding = settings.appearance.border.radius;
              in
              {
                text_color = rgb colors.base00;
                font_size = config.stylix.fonts.sizes.desktop;
                height = builtins.floor (config.stylix.fonts.sizes.desktop * 1.5 + 0.5);
                indicator_height = 0;
                inherit rounding;
                gradients = true;
                gradient_rounding = rounding;

                "col.active" = cfg'.group."col.border_active";
                "col.inactive" = cfg'.group."col.border_inactive";
                "col.locked_active" = cfg'.group."col.border_locked_active";
                "col.locked_inactive" = cfg'.group."col.border_locked_inactive";
              };
          };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          vfr = true;
          animate_manual_resizes = true;
          focus_on_activate = true;
        };
      };
  };
}
