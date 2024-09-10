{
  # This file contains settings for your system configuration.
  # It doesn't install anything but sets values that other parts of your system may use.

  dotfiles = {
    # User information
    username = "karun"; # Your username
    name = "Karun Sandhu"; # Your full name
    email = "129101708+MrSom3body@users.noreply.github.com"; # Your email for Git
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFKSJm8M+cxXmYVQMjKYtEMuP3pdYdIJBJzbm3NP/v2q karun@blackbox"; # Your SSH key for Git
    path = "/home/karun/dotfiles"; # Path to your dotfiles

    # System settings
    hostname = "blackbox"; # Hostname for your machine

    # Appearance settings
    theme = "gruvbox-dark-medium"; # Theme for your system (find more themes at https://github.com/tinted-theming/schemes)
    rounding = 15; # Window rounding (if supported)
    fontMono = "Fira Code Nerd Font"; # Monospace font
    fontSans = "Ubuntu Nerd Font"; # Sans-serif font

    # Default applications
    shell = "fish"; # Default shell
    editor = "hx"; # Default text editor
    terminal = "kitty"; # Default terminal
    browser = "firefox"; # Default web browser
    fileManager = "nautilus"; # Default GUI file manager
    terminalFileManager = "yazi"; # Default terminal file manager
  };
}
