{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez-experimental;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;
}
