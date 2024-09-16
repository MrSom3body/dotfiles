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
    wallpaper = ./walls/gruvbox/wave.png; # Wallpaper for WMs
    rounding = 15; # Window rounding (if supported)
    fontMono = "Fira Code Nerd Font"; # Monospace font
    fontSans = "Ubuntu Nerd Font"; # Sans-serif font

    # Default applications
    editor = "hx"; # Default text editor
    terminal = "kitty"; # Default terminal
    browser = "firefox"; # Default web browser
    fileManager = "nautilus"; # Default GUI file manager
    terminalFileManager = "yazi"; # Default terminal file manager
  };
}
