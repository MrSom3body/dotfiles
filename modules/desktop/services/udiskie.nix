{
  flake.modules.homeManager.desktop = {
    services.udiskie = {
      enable = true;
      tray = "auto";
      notify = true;
      automount = true;
      settings = {
        device_config = [
          {
            id_uuid = "2F3D-94F4";
            automount = true;
          }
          {
            id_uuid = "5f771662-6cb4-4bb9-b3ec-e08af519402f";
            automount = true;
            keyfile = "~/Pictures/butter_chicken.jpg";
          }

          # Default
          { automount = false; }
        ];
      };
    };

  };
}
