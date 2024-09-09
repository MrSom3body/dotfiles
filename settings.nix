{
  /*
  Setting anything here won't install it. It's just a configuration file.
  It will only set some values.
  */
  dotfiles = {
    # User settings
    username = "karun";
    name = "Karun Sandhu";
    email = "129101708+MrSom3body@users.noreply.github.com";
    key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFKSJm8M+cxXmYVQMjKYtEMuP3pdYdIJBJzbm3NP/v2q karun@blackbox";
    path = "/home/karun/dotfiles"; # Full path to this flake

    # System settings
    hostname = "blackbox"; # Before changing the hostname make sure a default.nix and home.nix are available under the hosts/HOSTNAME directory

    # Theming related settings
    theme = "gruvbox-dark-medium"; # Themes can be found at https://github.com/tinted-theming/schemes
    rounding = 15;
    # Use any font from the nerd-fonts package
    fontMono = "Fira Code Nerd Font";
    fontSans = "Ubuntu Nerd Font";

    # Default apps
    shell = "fish";
    editor = "hx";
    terminal = "kitty";
    browser = "firefox";
    fileManager = "nautilus";
    terminalFileManager = "yazi";
  };
}
