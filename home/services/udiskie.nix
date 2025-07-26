{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.udiskie;
in
{
  options.my.services.udiskie = {
    enable = mkEnableOption "a storage management service";
  };

  config = mkIf cfg.enable {
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
  };
}
