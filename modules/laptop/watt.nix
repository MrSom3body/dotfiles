{ inputs, ... }: {
  flake.modules.nixos.laptop = { pkgs, ... }: {
    services = {
      tuned.enable = false;
      tlp.enable = false;
      power-profiles-daemon.enable = false;
      watt = {
        enable = true;
        package = inputs.watt.packages.${pkgs.stdenv.hostPlatform.system}.watt;
      };
    };
  };
}
