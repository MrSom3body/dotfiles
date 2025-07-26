{
  imports = [
    ../../../system/optional/services/immich.nix
  ];

  services = {
    immich.accelerationDevices = [ "/dev/dri/renderD128" ];
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];
}
