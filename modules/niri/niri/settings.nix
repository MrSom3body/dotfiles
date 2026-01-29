{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.homeManager.niri = {
    programs.niri.settings = {
      input = {
        keyboard = {
          xkb = {
            layout = "at";
            options = "caps:swapescape";
          };
        };
        touchpad = {
          tap = true;
          dwt = true; # disable while typing
          natural-scroll = true;
          click-method = "clickfinger";
        };

        # Uncomment this to make the mouse warp to the center of newly focused windows.
        # warp-mouse-to-focus = true;

        # Focus windows and outputs automatically when moving the mouse into them.
        # Setting max-scroll-amount="0%" makes it work only on windows already fully on screen.
        # focus-follows-mouse max-scroll-amount="0%"
      };

      layout = {
        gaps = 10;

        # When to center a column when changing focus, options are:
        # - "never", default behavior, focusing an off-screen column will keep at the left
        #   or right edge of the screen.
        # - "always", the focused column will always be centered.
        # - "on-overflow", focusing a column will center it if it doesn't fit
        #   together with the previously focused column.
        center-focused-column = "never";

        # You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
        preset-column-width = [
          # Proportion sets the width as a fraction of the output width, taking gaps into account.
          # For example, you can perfectly fit four windows sized "proportion 0.25" on an output.
          # The default preset widths are 1/3, 1/2 and 2/3 of the output.
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];

        # You can also customize the heights that "switch-preset-window-height" (Mod+Shift+R) toggles between.
        preset-window-heights = [
          { proportion = 1.0 / 2.0; }
          { proportion = 1.0; }
        ];

        # You can change the default width of the new windows.
        default-column-width = {
          proportion = 1.0/2.0;
        };
        # If you leave the brackets empty, the windows themselves will decide their initial width.

        # By default focus ring and border are rendered as a solid background rectangle
        # behind windows. That is, they will show up through semitransparent windows.
        # This is because windows using client-side decorations can have an arbitrary shape.
        #
        # If you don't like that, you should uncomment `prefer-no-csd` below.
        # Niri will draw focus ring and border *around* windows that agree to omit their
        # client-side decorations.
        #
        # Alternatively, you can override it with a window rule called
        # `draw-border-with-background`.

        # You can change how the focus ring looks.
        focus-ring = {
          enable = true;

          # How many logical pixels the ring extends out from the windows.
          width = meta.appearance.border.size;
        };

        # You can also add a border. It's similar to the focus ring, but always visible.
        border = {
          enable = true;
          width = meta.appearance.border.size;
        };

        shadow.enable = true;

        # Struts shrink the area occupied by windows, similarly to layer-shell panels.
        # You can think of them as a kind of outer gaps. They are set in logical pixels.
        # Left and right struts will cause the next window to the side to always be visible.
        # Top and bottom struts will simply add outer gaps in addition to the area occupied by
        # layer-shell panels and regular gaps.
        struts = {
          left = 64;
          right = 64;
          # top = 64;
          # bottom = 64;
        };
      };

      hotkey-overlay.skip-at-startup = true;

      # Uncomment this line to ask the clients to omit their client-side decorations if possible.
      # If the client will specifically ask for CSD, the request will be honored.
      # Additionally, clients will be informed that they are tiled, removing some client-side rounded corners.
      # This option will also fix border/focus ring drawing behind some semitransparent windows.
      # After enabling or disabling this, you need to restart the apps for this to take effect.
      prefer-no-csd = true;

      # You can change the path where screenshots are saved.
      # A ~ at the front will be expanded to the home directory.
      # The path is formatted with strftime(3) to give you the screenshot date and time.
      screenshot-path = "~/Pictures/Screenshots/%Y-%m-%dT%H:%M:%S.png";
    };
  };
}
