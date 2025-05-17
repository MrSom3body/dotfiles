{pkgs, ...}: {
  imports = [
    ./podman.nix
  ];

  environment = {
    systemPackages = [pkgs.containerlab];
    shellAliases = {
      clab = "containerlab";
    };
  };
}
