{ pkgs, ... }:
{
  virtualisation = {
    libvirtd = {
      allowedBridges = [
        "nm-bridge"
        "virbr0"
      ];
      enable = true;
      qemu = {
        runAsRoot = false;
        vhostUserPackages = [ pkgs.virtiofsd ];
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
      gnome-boxes
      ;
  };
}
