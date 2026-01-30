{
  flake.modules.nixos.desktop = {
    system.autoUpgrade.operation = "boot";
  };
}
