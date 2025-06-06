{
  config,
  pkgs,
  settings,
  ...
}: {
  services.swayosd = {
    enable = true;
    topMargin = 0.5;
    stylePath = let
      inherit (settings.appearance) border;
      colors = config.lib.stylix.colors.withHashtag;
    in
      pkgs.writeText "style.css" # css
      
      ''
        window#osd {
          border-radius: ${toString border.radius}px;
          border: solid ${colors.base0D} ${toString border.size}px;
          background: alpha(${colors.base00}, ${toString config.stylix.opacity.popups});
        }

        #container {
          margin: 8px;
        }

        window#osd image,
        window#osd label {
          color: ${colors.base05};
        }

        window#osd progressbar:disabled,
        window#osd image:disabled {
          opacity: 0.5;
        }

        window#osd trough {
          background: alpha(${colors.base05}, 0.5);
        }

        window#osd progress {
          background: ${colors.base05};
        }
      '';
  };
}
