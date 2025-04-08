{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../home/profiles/laptop.nix

    # programs
    ../../home/programs/games
    ../../home/programs/school
    ../../home/programs/solaar.nix # Logitech Mouse
    ../../home/programs/vesktop.nix # Discord

    # system services
    ../../home/services/system/kdeconnect.nix
    ../../home/services/system/tailray.nix
    ../../home/services/system/rclone.nix
    ../../home/services/system/syncthing.nix
  ];

  my.programs.rclone = {
    enable = true;
    protonDriveBackup = {
      enable = true;
      filters = ''
        - {{\.?venv}}/**
        - .devenv/**
        - .direnv/**
        + /Desktop/**
        + /Documents/**
        + /Games/Saves/**
        + /Music/**
        + /Notes/**
        + /Pictures/**
        + /Templates/**
        + /Videos/**
        - *
        - *
      '';
    };
  };

  gtk.gtk3.bookmarks = map (dir: "file://${config.home.homeDirectory}/" + dir) [
    "Desktop"
    "Documents"
    "Documents/Codes"
    "Documents/Schule/2024-25"
    "Downloads"
    "Games"
    "Music"
    "Notes"
    "Sync"
    "Videos"
    "dotfiles"
  ];

  home.packages = with pkgs; [
    # Communication & Social Media
    element-desktop # Matrix client
    signal-desktop

    # Misc
    ente-auth
    fragments
    pika-backup
    proton-pass
    protonvpn-gui
  ];
}
