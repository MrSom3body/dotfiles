{
  flake.modules.nixos.libvirtd =
    { pkgs, ... }:
    {
      virtualisation = {
        libvirtd = {
          enable = true;
          allowedBridges = [
            "nm-bridge"
            "virbr0"
            "virbr1"
            "virbr2"
          ];
          qemu = {
            runAsRoot = false;
            vhostUserPackages = [ pkgs.virtiofsd ];
            swtpm.enable = true;
          };
        };
        spiceUSBRedirection.enable = true;
      };

      services = {
        spice-vdagentd.enable = true;
        spice-webdavd.enable = true;
      };

      programs.virt-manager.enable = true;

      environment.systemPackages = builtins.attrValues {
        inherit (pkgs)
          gnome-connections
          ;
      };
    };
}
