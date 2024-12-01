{pkgs-stable, ...}: {
  hardware.opentabletdriver = {
    enable = true;
    # TODO switch back to unstable when https://github.com/NixOS/nixpkgs/pull/360389 gets merged into nixos-unstable
    package = pkgs-stable.opentabletdriver;
    daemon.enable = true;
  };
}
