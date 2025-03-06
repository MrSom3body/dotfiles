{
  # This file contains settings for your system configuration.
  # It doesn't install anything but sets values that other parts of your system may use.

  settings = hostname: rec {
    # System settings
    inherit hostname;
    user = "karun";
    username = "Karun Sandhu";
    path = "/home/karun/dotfiles"; # Path to your dotfiles

    # Appearance settings
    appearance = {
      dark-theme = "gruvbox-material-dark-medium"; # Dark theme for your system (find more themes at https://github.com/tinted-theming/schemes)
      light-theme = "one-light"; # Light theme for your system (find more themes at https://github.com/tinted-theming/schemes)
      polarity = "dark"; # Default mode
      wallpaper = ./walls/gruvbox/secluded-grove.png; # Wallpaper for WMs

      border = {
        size = 2;
        radius = 7;
      };

      fonts = {
        # fonts must be Nerd Fonts
        mono = {
          # Monospace font
          name = "FiraCode Nerd Font";
          pkgName = "fira-code";
          size = 13;
        };
        sans = {
          # Sans-serif font
          name = "Ubuntu Nerd Font";
          pkgName = "ubuntu";
          size = 14;
        };
      };
    };

    # Program options
    programs = {
      editor = "hx"; # Default text editor
      terminal = "foot"; # Default terminal
      browser = "zen"; # Default web browser
      fileManager = "nautilus"; # Default GUI file manager
      terminalFileManager = "yazi"; # Default terminal file manager
      git = {
        username = user;
        mail = "129101708+MrSom3body@users.noreply.github.com";
      };
    };
  };
}
