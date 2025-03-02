{
  lib,
  config,
  settings,
  ...
}: {
  imports = [
    ../../system/profiles/workstation.nix
  ];

  services.greetd.settings.initial_session = {
    command = "${lib.getExe config.programs.uwsm.package} start hyprland-uwsm.desktop";
    inherit (settings) user;
  };
}
