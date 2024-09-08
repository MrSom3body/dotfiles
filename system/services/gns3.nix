{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gns3-gui
    gns3-server
  ];
}
