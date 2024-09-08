{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez5-experimental;
    settings = {
      # make Xbox Series X controller work
      General = {
        Class = "0x000100";
        ControllerMode = "bredr";
        FastConnectable = true;
        JustWorksRepairing = "always";
        Privacy = "device";
        # Battery info for Bluetooth devices
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;
}
