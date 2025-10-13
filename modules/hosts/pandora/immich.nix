{
  flake.modules.nixos."hosts/pandora" = {
    services.immich.accelerationDevices = [ "/dev/dri/renderD128" ];

    users.users.immich.extraGroups = [
      "video"
      "render"
    ];
  };
}
