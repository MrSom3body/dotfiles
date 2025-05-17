_: {
  services.ddns-updater = {
    enable = true;
    environment = {
      LISTENING_ADDRESS = "127.0.0.1:8000";
    };
  };
}
