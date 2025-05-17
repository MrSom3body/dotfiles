{
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = 2283;
  };

  users.users.immich.extraGroups = ["video" "render"];
}
