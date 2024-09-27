{pkgs, ...}: {
  imports = [
    ./mangohud.nix
  ];

  home.packages = with pkgs; [
    goverlay
    heroic
    ludusavi
    modrinth-app
    r2modman
  ];
}
