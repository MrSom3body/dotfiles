{
  flake.modules.nixos.nixos = {
    system.tools.nixos-rebuild.enableRun0Elevation = true;
  };
}
