{
  flake.modules.nixos.laptop = {
    system.autoUpgrade.operation = "boot";
  };
}
