{
  flake.modules = {
    nixos.bluetooth = {
      hardware.bluetooth.enable = true;
    };

    homeManager.bluetooth = { pkgs, ... }: { home.packages = [ pkgs.bluetui ]; };
  };
}
