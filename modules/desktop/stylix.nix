{ config, inputs, ... }:
{
  flake.modules = {
    nixos.desktop.imports = [ config.flake.modules.nixos.stylix ];
    homeManager.desktop.imports = [ config.flake.modules.homeManager.stylix ];

    nixos.stylix =
      { pkgs, ... }:
      {
        imports = [ inputs.stylix.nixosModules.stylix ];
        stylix = {
          enable = true;
          image = ../../walls/gruvbox/secluded-grove.png;
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";

          fonts =
            let
              sans = {
                name = "Ubuntu Nerd Font";
                package = pkgs.nerd-fonts.ubuntu;
              };
            in
            {
              sizes = {
                applications = 14;
                desktop = 14;
                popups = 14;
                terminal = 13;
              };
              sansSerif = sans;
              serif = sans;
              monospace = {
                name = "Iosevka Nerd Font";
                package = pkgs.nerd-fonts.iosevka;
              };
              emoji = {
                package = pkgs.noto-fonts-color-emoji;
                name = "Noto Color Emoji";
              };
            };

          cursor = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Classic";
            size = 24;
          };

          # TODO remove when https://github.com/nix-community/stylix/pull/2337 gets merged
          targets.kmscon.enable = false;
          targets.fish.enable = false;

          # opacity = {
          #   applications = 0.95;
          #   desktop = 0.95;
          #   popups = 0.75;
          #   terminal = 0.95;
          # };
        };
      };

    homeManager.stylix =
      {
        lib,
        pkgs,
        config,
        ...
      }:
      {
        stylix = {
          overlays.enable = false;

          targets = {
            firefox.profileNames = [ "default" ];
            zen-browser.profileNames = [ "default" ];
            fish.enable = false;
            kitty.variant256Colors = true;
            rofi.enable = false;
            waybar = {
              addCss = false;
              font = "sansSerif";
            };
          };

          icons = {
            enable = true;
            package = pkgs.papirus-icon-theme;
            light = "Papirus-Light";
            dark = "Papirus-Dark";
          };
        };

        # TODO remove when https://github.com/nix-community/stylix/issues/2250 gets resolved
        gtk.gtk4.theme = lib.mkForce config.gtk.theme;
      };
  };
}
