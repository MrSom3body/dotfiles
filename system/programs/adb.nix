{settings, ...}: {
  programs.adb.enable = true;
  users.users.${settings.user}.extraGroups = ["adbusers"];
}
