{ lib, ... }: {
  flake.modules.nixos.desktop =
    { pkgs, config, ... }:
    let
      tuigreet-config = (pkgs.formats.toml { }).generate "tuigreet-config.toml" {
        display.show_time = true;
        user_menu.enabled = true;
        background = {
          kind = "doom";
          doom.height = 4;
        };
        secret.mode = "characters";
        layout = {
          width = 60;
          window_padding = 2;
          container_padding = 1;
          prompt_padding = 1;
        };

        sessions =
          let
            sessionData = config.services.displayManager.sessionData.desktops;
          in
          {
            sessions_dirs = [ "${sessionData}/share/wayland-sessions" ];
            xsessions_dirs = [ "${sessionData}/share/xsessions" ];
          };
        remember = {
          username = true;
          session = true;
          user_session = true;
        };
      };
    in
    {
      services = {
        greetd = {
          enable = true;
          settings = {
            default_session = {
              user = "greeter";
              command = "${lib.getExe' pkgs.tuigreet "tuigreet"} --config ${tuigreet-config}";
            };
            terminal.vt = 1;
          };
        };
      };

      systemd.tmpfiles.rules = [ "d /var/cache/tuigreet 0755 greeter greeter" ];

      security.pam.services.greetd.fprintAuth = false;
      security.pam.services.greetd-password.fprintAuth = false;
    };
}
