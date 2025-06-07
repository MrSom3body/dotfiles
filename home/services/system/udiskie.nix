{lib, ...}: {
  services.udiskie = {
    enable = true;
    tray = "auto";
    notify = true;
    automount = true;
    settings = {
      device_config = [
        {
          id_uuid = "0FA4-0BB5";
          automount = true;
        }
        {
          id_uuid = "4e30e281-8d9b-43a7-a0c2-d0fb7f1e9cc2";
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
