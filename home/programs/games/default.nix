{pkgs, ...}: {
  imports = [
    ./ludusavi.nix
    ./mangohud.nix
  ];

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      bottles
      goverlay
      heroic
      mindustry-wayland
      modrinth-app
      r2modman
      ;
  };
}
