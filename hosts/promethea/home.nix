{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings.permission = [
    ### Keyboards ###
    "video-bus, keyboard, allow"
    "asus-wmi-hotkeys, keyboard, allow"
    "at-translated-set-2-keyboard, keyboard, allow"

    # Mechanical Keyboard
    "sonix-usb-device-system-control, keyboard, allow"
    "sonix-usb-device, keyboard, allow"
    "sonix-usb-device-keyboard, keyboard, allow"
    "sonix-usb-device-consumer-control, keyboard, allow"

    # Wacom Tablet
    "opentabletdriver-virtual-keyboard, keyboard, allow"

    # Bluetooth Periphery
    "nothing-ear-\(avrcp\), keyboard, allow"
    "jbl-go-2-\(avrcp\), keyboard, allow"
    "jbl-go-4-von-karun-(avrcp), keyboard, allow"

    # Deny everything else
    ".*, keyboard, deny"
  ];

  my = {
    systemType = 3;

    games.enable = true;

    office.mail.enable = true;

    programs = {
      discord.enable = true;

      rclone = {
        enable = true;
        protonDriveBackup = {
          enable = true;
          filters = ''
            - {{\.?venv}}/**
            - .devenv/**
            - .direnv/**
            - /Documents/Codes/nixpkgs/**
            - /Documents/Schule/2024-25/INSY/oracle-volume/**
            + /Desktop/**
            + /Documents/**
            + /Games/Saves/**
            + /Music/**
            + /Notes/**
            + /Pictures/**
            + /Templates/**
            + /Videos/**
            - *
          '';
        };
      };

      # cli
      comma.enable = true;
      direnv.enable = true;
      gh.enable = true;
      gitui.enable = true;
      tealdeer.enable = true;
      tokei.enable = true;
    };

    services = {
      solaar = {
        enable = true;
        rules = ''
          ---
          - MouseGesture: Mouse Right
          - Execute: [hyprctl, dispatch, workspace, r+1]
          ...
          ---
          - MouseGesture: Mouse Left
          - Execute: [hyprctl, dispatch, workspace, r-1]
          ...
        '';
      };
      syncthing.enable = true;
    };

    school.enable = true;
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

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      # cli
      glow
      # Communication & Social Media
      element-desktop # Matrix client
      signal-desktop-bin
      # Misc
      ente-auth
      fragments
      pika-backup
      proton-pass
      protonvpn-gui
      jellyfin-media-player
      ;
  };
}
