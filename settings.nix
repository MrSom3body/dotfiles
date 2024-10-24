{
  # This file contains settings for your system configuration.
  # It doesn't install anything but sets values that other parts of your system may use.

  dotfiles = {
    # System settings
    hostname = "blackbox"; # Hostname for your machine
    path = "/home/karun/dotfiles"; # Path to your dotfiles

    # Appearance settings
    theme = "gruvbox-dark-medium"; # Theme for your system (find more themes at https://github.com/tinted-theming/schemes)
    polarity = "dark"; # Set light or dark mode
    wallpaper = ./walls/gruvbox/abstract-shapes.png; # Wallpaper for WMs
    rounding = 15; # Window rounding (if supported)
    fonts = {
      # fonts must be Nerd Fonts
      mono = {
        # Monospace font
        name = "Fira Code Nerd Font";
        pkgName = "FiraCode";
        size = 13;
      };
      sans = {
        # Sans-serif font
        name = "Ubuntu Nerd Font";
        pkgName = "Ubuntu";
        size = 14;
      };
    };

    # Default applications
    editor = "hx"; # Default text editor
    terminal = "kitty"; # Default terminal
    browser = "firefox-beta"; # Default web browser
    fileManager = "nautilus"; # Default GUI file manager
    terminalFileManager = "yazi"; # Default terminal file manager
  };
}
