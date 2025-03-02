{
  config,
  settings,
  ...
}: {
  services.swayosd = {
    enable = true;
    topMargin = 0.5;
  };

  home.file.".config/swayosd/style.css".text = with config.lib.stylix.colors.withHashtag; let
    inherit (settings.appearance) border;
  in
    # css
    ''
      window {
        border-radius: ${toString border.radius};
        border: solid ${base0D} ${toString border.size};
        background: alpha(${base00}, ${toString config.stylix.opacity.popups});
      }

      image,
      label {
        color: ${base05};
      }

      progressbar:disabled,
      image:disabled {
        opacity: 0.5;
      }

      trough {
        background: alpha(${base05}, 0.5);
      }

      progress {
        background: ${base05};
      }
    '';
}
