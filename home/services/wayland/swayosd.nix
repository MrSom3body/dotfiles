{
  config,
  pkgs,
  settings,
  ...
}: {
  services.swayosd = {
    enable = true;
    topMargin = 0.5;
    stylePath = with config.lib.stylix.colors.withHashtag; let
      inherit (settings.appearance) border;
    in
      pkgs.writeText "style.css" # css
      
      ''
        window#osd {
          border-radius: ${toString border.radius}px;
          border: solid ${base0D} ${toString border.size}px;
          background: alpha(${base00}, ${toString config.stylix.opacity.popups});
        }

        #container {
          margin: 8px;
        }

        window#osd image,
        window#osd label {
          color: ${base05};
        }

        window#osd progressbar:disabled,
        window#osd image:disabled {
          opacity: 0.5;
        }

        window#osd trough {
          background: alpha(${base05}, 0.5);
        }

        window#osd progress {
          background: ${base05};
        }
      '';
  };
}
