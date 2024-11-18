{pkgs, ...}: {
  imports = [
    ./ludusavi.nix
    ./mangohud.nix
  ];

  home.packages = with pkgs; [
    goverlay
    heroic
    mindustry-wayland
    modrinth-app
    r2modman
  ];
}
