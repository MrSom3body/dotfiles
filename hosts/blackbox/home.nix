{pkgs, ...}: {
  imports = [
    # home manager stuff
    ../../home

    # editors
    ../../home/editors/helix

    # terminals
    ../../home/terminal/emulators/alacritty.nix
    ../../home/terminal/emulators/foot.nix
    ../../home/terminal/emulators/kitty.nix

    # programs
    ../../home/programs
    ../../home/programs/games
    ../../home/programs/school
    ../../home/programs/wayland

    # media services
    ../../home/services/media/playerctl.nix

    # system services
    ../../home/services/system/gpg-agent.nix
    ../../home/services/system/kdeconnect.nix
    ../../home/services/system/polkit.nix
    ../../home/services/system/syncthing.nix
    ../../home/services/system/udiskie.nix

    # wayland services
    ../../home/services/wayland/cliphist.nix
    ../../home/services/wayland/fnott
    ../../home/services/wayland/gammastep.nix
    ../../home/services/wayland/hypridle.nix
    ../../home/services/wayland/hyprpaper.nix
    ../../home/services/wayland/swayosd.nix

    # styles
    ../../home/style/stylix.nix
    ../../home/style/gtk.nix
  ];

  systemd.user.services.proton-drive = {
    Unit = {
      Description = "Mount a Proton Drive Folder automatically";
      After = ["network-online.target"];
    };
    Service = {
      Type = "notify";
      ExecStartPre = "/usr/bin/env mkdir -p %h/ProtonDrive";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/rclone/rclone.conf --vfs-cache-mode writes mount --allow-non-empty \"proton:Computers/blackbox\" \"ProtonDrive\"";
      ExecStop = "/bin/fusermount -u %h/ProtonDrive/%i";
    };
    Install.WantedBy = ["default.target"];
  };
}
