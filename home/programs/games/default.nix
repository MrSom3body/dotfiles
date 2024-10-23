{pkgs, ...}: {
  imports = [
    ./mangohud.nix
  ];

  home.packages = with pkgs; [
    goverlay
    heroic
    ludusavi
    mindustry-wayland
    modrinth-app
    r2modman
  ];
}
