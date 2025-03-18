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
    # TODO switch back to unstable when
    # https://github.com/NixOS/nixpkgs/pull/389948 gets merged
    stable.modrinth-app
    r2modman
  ];
}
