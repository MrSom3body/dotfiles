{
  config,
  pkgs,
  ...
}:
{
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
    };

    terminal = {
      programs = {
        comma.enable = true;
        direnv.enable = true;
        gh.enable = true;
        gitui.enable = true;
        ntfy.enable = true;
        tealdeer.enable = true;
        tokei.enable = true;
        zellij.enable = true;
      };
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
          ---
          - MouseGesture: Mouse Up
          - Execute: [hyprctl, dispatch, hyprexpo:expo, toggle]
          ...
        '';
        extraArgs = [ "--restart-on-wake-up" ];
      };
      syncthing.enable = true;
    };

    school.enable = true;
  };

  gtk.gtk3.bookmarks = map (dir: "file://${config.home.homeDirectory}/" + dir) [
    "Desktop"
    "Documents"
    "Downloads"
    "Games"
    "Music"
    "Videos"
    "dotfiles"
    "Documents/Codes"
    "Documents/Notes"
    "Documents/Schule/2025-26"
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      # cli
      glow
      # communication & social media
      element-desktop # Matrix client
      signal-desktop-bin
      # media
      jellyfin-media-player
      # proton
      proton-authenticator
      proton-pass
      protonvpn-gui
      # misc
      exercism
      fragments
      pika-backup
      ;
  };
}
