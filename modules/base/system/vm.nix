{
  flake.modules.nixos.nixos = {
    virtualisation.vmVariant = {
      virtualisation = {
        memorySize = 8192;
        cores = 4;

        qemu.options = [
          # Better display option
          "-vga virtio"
          "-display gtk,zoom-to-fit=false,grab-on-hover=on"
          # Enable copy/paste does not work :(
          # "-chardev qemu-vdagent,id=ch1,name=vdagent,clipboard=on"
          # "-device virtio-serial-pci"
          # "-device virtserialport,chardev=ch1,id=ch1,name=com.redhat.spice.0"
        ];
      };

      services = {
        xserver.drivers = [ "virtio" ];
        qemuGuest.enable = true;
        spice-vdagentd.enable = true;
        spice-autorandr.enable = true;
      };
    };
  };
}
