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
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
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
