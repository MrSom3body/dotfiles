{pkgs, ...}: {
  virtualisation = {
    libvirtd = {
      allowedBridges = [
        "nm-bridge"
        "virbr0"
      ];
      enable = true;
      qemu.runAsRoot = false;
    };
    spiceUSBRedirection.enable = true;
  };

  services.spice-vdagentd.enable = true;

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-connections
    gnome-boxes
  ];
}
