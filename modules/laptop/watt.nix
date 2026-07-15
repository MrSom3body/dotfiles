{ inputs, ... }: {
  flake.modules.nixos.laptop = {
    disabledModules = [ "services/hardware/watt.nix" ];
    imports = [ inputs.watt.nixosModules.default ];

    services = {
      tuned.enable = false;
      tlp.enable = false;
      power-profiles-daemon.enable = false;
      watt.enable = true;
    };
  };
}
