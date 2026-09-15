{
  flake.modules.nixos.nixos = {
    security.polkit = {
      enable = true;
      enablePkexecWrapper = false;
    };
  };
}
