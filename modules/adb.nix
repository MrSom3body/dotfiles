{
  flake.modules.nixos.adb = {
    programs.adb.enable = true;
    users.users.karun.extraGroups = [ "adbusers" ];
  };
}
