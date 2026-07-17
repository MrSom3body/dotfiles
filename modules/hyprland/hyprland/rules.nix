{ lib, ... }: {
  flake.modules.homeManager.hyprland = { config, ... }: {
    wayland.windowManager.hyprland.settings =
      let
        floatingSize = {
          w = 900;
          h = 600;
        };

        toMatch =
          list:
          let
            elements = lib.concatStringsSep "|" list;
          in
          "^(${elements})$";
      in
      {
        window_rule = [
          # inhibit idle when fullscreen
          {
            match = {
              fullscreen = true;
            };
            idle_inhibit = "always";
          }

          # Smart Gaps
          {
            match = {
              workspace = "w[tv1]s[false]";
              float = false;
            };
            border_size = 0;
            rounding = 0;
            no_shadow = true;
          }
          {
            match = {
              workspace = "f[1]s[false]";
              float = false;
            };
            border_size = 0;
            rounding = 0;
          }
          {
            match = {
              workspace = "f[f1]s[false]";
              float = false;
            };
            no_shadow = true;
          }

          # Fix some dragging issues with XWayland
          {
            match = {
              class = "^$";
              title = "^$";
              xwayland = true;
              float = true;
              fullscreen = false;
              pin = false;
            };
            no_focus = true;
          }

          # Ignore maximize requests from apps
          {
            match = {
              class = ".*";
            };
            suppress_event = "maximize";
          }

          # Move apps to workspaces
          {
            match = {
              class = toMatch [
                "Todoist"
                "@lunatask/electron"
                "io.github.alainm23.planify"
              ];
            };
            workspace = "special:todo silent";
          }
          {
            match = {
              class = "^(spotify)$";
            };
            workspace = "special:spotify silent";
          }
          {
            match = {
              class = "^(vesktop)$";
            };
            workspace = "special:discord silent";
          }

          # Dim some programs
          {
            match = {
              class = toMatch [
                "xdg-desktop-portal-gtk"
                "polkit-gnome-authentication-agent-1"
              ];
            };
            dim_around = true;
          }

          # Floating utilities
          {
            match = {
              class = toMatch [
                "nm-connection-editor"
                "impala"
                "bluetui"
                ".blueman-manager-wrapped"
                "wiremix"
                "com.saivert.pwvucontrol"
                "dua"
              ];
            };
            float = true;
            size = "${toString floatingSize.w} ${toString floatingSize.h}";
            center = true;
          }

          # Udiskie
          {
            match = {
              class = "^(udiskie)$";
            };
            float = true;
            center = true;
          }

          # Picture-in-Picture
          {
            match = {
              title = "^(Picture-in-Picture)$";
            };
            float = true;
            pin = true;
          }

          # Proton Pass
          {
            match = {
              class = "^(Proton Pass)$";
            };
            float = true;
            no_screen_share = true;
          }

          # GNS3
          {
            match = {
              class = "^(gns3)$";
              title = "^(Change hostname)$";
            };
            stay_focused = false;
          }

          # Anki
          {
            match = {
              class = "^(Anki)$";
              title = "^(Add)$";
            };
            float = true;
            size = "600 400";
            center = true;
          }

          # Calculator
          {
            match = {
              class = toMatch [
                "org.gnome.Calculator"
                "qalculate-gtk"
              ];
            };
            float = true;
          }

          # Clock
          {
            match = {
              class = "^(org.gnome.clocks)$";
            };
            float = true;
            size = "800 600";
          }

          # Grayjay
          {
            match = {
              title = "^(Grayjay)$";
            };
            tile = true;
          }

          # Games
          {
            match = {
              class = toMatch [
                "Minecraft.*"
                "steam_app_.*"
                "hl2_linux"
              ];
            };
            immediate = true;
          }
          {
            match = {
              class = "^(steam_app_960090)$";
            };
            render_unfocused = true;
          }
        ];

        layer_rule =
          let
            bars = [ "waybar" ];

            menus = [
              "rofi"
              "launcher"
              "vicinae"
            ];

            notifications = [
              "swaync-control-center"
              "notifications"
            ];

            blurred = lib.concatLists [
              bars
              menus
              notifications
            ];
          in
          [
            {
              match = {
                namespace = toMatch menus;
              };
              animation = "slide";
              dim_around = true;
            }
            {
              match = {
                namespace = toMatch notifications;
              };
              animation = "slide right";
            }
          ]
          ++ lib.optional (config.stylix.opacity.desktop != 1.0) {
            match = {
              namespace = toMatch blurred;
            };
            blur = true;
            ignore_alpha = 0;
          };

        workspace_rule = [
          # Smart Gaps
          {
            workspace = "w[tv1]s[false]";
            gaps_out = 0;
            gaps_in = 0;
          }
          {
            workspace = "f[1]s[false]";
            gaps_out = 0;
            gaps_in = 0;
          }
        ];
      };
  };
}
