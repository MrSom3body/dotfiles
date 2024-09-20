{pkgs, ...}: {
  services.gns3-server = {
    enable = true;
    dynamips.enable = true;
    ubridge.enable = true;
    vpcs.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gns3-gui
    inetutils
  ];
}
