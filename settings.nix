{
  # This file contains settings for your system configuration.
  # It doesn't install anything but sets values that other parts of your system may use.

  settings = hostname: {
    # System settings
    inherit hostname;
    path = "/home/karun/dotfiles"; # Path to your dotfiles

    # Program options
    programs = {
      editor = "hx"; # Default text editor
      terminal = "ghostty"; # Default terminal
      browser = "zen"; # Default web browser
      fileManager = "nautilus"; # Default GUI file manager
      terminalFileManager = "yazi"; # Default terminal file manager
      git = {
        username = "Karun Sandhu";
        mail = "129101708+MrSom3body@users.noreply.github.com";
      };
    };
  };
}
