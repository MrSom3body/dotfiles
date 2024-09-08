{...}: {
  services.udiskie = {
    enable = true;
    tray = "auto";
    notify = true;
    automount = true;
    settings = {
      device_config = [
        {
          id_uuid = "9882-A313";
          automount = true;
        }
        {
          id_uuid = "9882-A313";
          automount = true;
          keyfile = "~/Pictures/profile.jpg";
        }
        {automount = false;}
      ];
    };
  };
}
