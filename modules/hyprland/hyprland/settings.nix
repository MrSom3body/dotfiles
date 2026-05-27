{ lib, config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.hyprland =
    { config, ... }:
    let
      inherit (config.wayland.windowManager.hyprland) layout;
      inherit (meta.appearance) border;
      inherit (config.lib.stylix) colors;
      lua = lib.generators.mkLuaInline;
      rgb = color: "rgb(${color})";

      groupBorderActive = rgb colors.base0D;
      groupBorderInactive = rgb colors.base03;
      groupBorderLockedActive = rgb colors.base0C;
      groupBorderLockedInactive = rgb colors.base0B;
    in
    {
      wayland.windowManager.hyprland.settings = lib.mkMerge [
        {
          monitor = [
            {
              output = "";
              mode = "preferred";
              position = "auto";
              scale = "auto";
            }
          ];

          workspace_rule = [
            {
              workspace = "1";
              monitor = "eDP-1";
              default = true;
            }
            {
              workspace = "2";
              monitor = "eDP-1";
              default = true;
            }
            {
              workspace = "3";
              monitor = "eDP-1";
              default = true;
            }
          ];

          on = [
            {
              _args = [
                "hyprland.start"
                (lua /* lua */ ''
                  function()
                    hl.exec_cmd("uwsm finalize")
                    hl.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 1")
                  end'')
              ];
            }
          ];

          config = lib.mkMerge [
            {
              general = {
                inherit layout;
                border_size = border.size;
                gaps_in = 5;
                gaps_out = 10;
                resize_on_border = false;
                allow_tearing = true;
              };

              render.new_render_scheduling = true;

              decoration = {
                rounding = border.radius;
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
                sensitivity = 0;
                follow_mouse = 1;
                scroll_method = "2fg";
                touchpad = {
                  disable_while_typing = true;
                  tap_button_map = "lrm";
                  tap_to_click = true;
                  tap_and_drag = true;
                };
              };

              gestures = {
                workspace_swipe_invert = false;
                workspace_swipe_direction_lock = false;
                workspace_swipe_forever = true;
                workspace_swipe_use_r = true;
              };

              dwindle = {
                preserve_split = false;
              };

              master = {
                new_status = "master";
              };

              scrolling = {
                column_width = 0.5;
                focus_fit_method = 1;
                explicit_column_widths = "0.333333, 0.5, 0.666667, 1";
                follow_min_visible = 0.4;
              };

              cursor = {
                no_hardware_cursors = false;
                use_cpu_buffer = true;
              };

              group = lib.mkForce {
                "col.border_active" = groupBorderActive;
                "col.border_inactive" = groupBorderInactive;
                "col.border_locked_active" = groupBorderLockedActive;
                "col.border_locked_inactive" = groupBorderLockedInactive;
                groupbar =
                  let
                    rounding = border.radius;
                  in
                  {
                    text_color = rgb colors.base00;
                    font_size = config.stylix.fonts.sizes.desktop;
                    height = builtins.floor (config.stylix.fonts.sizes.desktop * 1.5 + 0.5);
                    indicator_height = 0;
                    inherit rounding;
                    gradients = true;
                    gradient_rounding = rounding;
                    "col.active" = groupBorderActive;
                    "col.inactive" = groupBorderInactive;
                    "col.locked_active" = groupBorderLockedActive;
                    "col.locked_inactive" = groupBorderLockedInactive;
                  };
              };

              misc = {
                allow_session_lock_restore = true;
                disable_splash_rendering = true;
                animate_manual_resizes = true;
                focus_on_activate = true;
              };
            }
          ];

          animation = [
            {
              leaf = "fade";
              enabled = true;
              speed = 4;
              bezier = "default";
            }
            {
              leaf = "border";
              enabled = true;
              speed = 2;
              bezier = "default";
            }
            {
              leaf = "windows";
              enabled = true;
              speed = 3;
              bezier = "default";
              style = "slide";
            }
          ];

          gesture = [
            {
              fingers = 4;
              direction = "pinch";
              action = lua ''function() hl.exec_cmd("loginctl lock-session") end'';
            }
          ];
        }

        (lib.mkIf (layout != "scrolling") {
          animation = [
            {
              leaf = "workspaces";
              enabled = true;
              speed = 2;
              bezier = "default";
              style = "slide";
            }
          ];
          gesture = [
            {
              fingers = 3;
              direction = "horizontal";
              action = "workspace";
            }
          ];
        })

        (lib.mkIf (layout == "scrolling") {
          animation = [
            {
              leaf = "workspaces";
              enabled = true;
              speed = 2;
              bezier = "default";
              style = "slidevert";
            }
          ];
          gesture = [
            {
              fingers = 3;
              direction = "horizontal";
              action = "scroll_move";
            }
            {
              fingers = 3;
              direction = "vertical";
              action = "workspace";
            }
          ];
        })
      ];
    };
}
