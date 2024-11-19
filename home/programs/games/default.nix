{pkgs, ...}: {
  imports = [
    ./ludusavi.nix
    ./mangohud.nix
  ];

  home.packages = with pkgs; [
    bottles
    goverlay
    heroic
    mindustry-wayland
    modrinth-app
    r2modman
  ];
}
