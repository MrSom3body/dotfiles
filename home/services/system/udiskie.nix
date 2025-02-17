{lib, ...}: {
  services.udiskie = {
    enable = true;
    tray = "auto";
    notify = true;
    automount = true;
    settings = {
      device_config = [
        {
          id_uuid = "2451-4927";
          automount = true;
        }
        {
          id_uuid = "f7680595-9723-4caa-856f-2f5bc54f65bf";
          automount = true;
          keyfile = "~/.face";
        }

        # Default
        {
          automount = false;
        }
      ];
    };
  };

  systemd.user.services.udiskie.Unit.After = lib.mkForce "graphical-session.target";
}
