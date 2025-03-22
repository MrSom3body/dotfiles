{
  services = {
    send = {
      enable = true;
      host = "127.0.0.1";
      port = 1443;
      environment = {
        MAX_EXPIRE_SECONDS = 345600;
        MAX_DOWNLOADS = 10;
        DOWNLOAD_COUNTS = "1,2,3,5,10";
        EXPIRE_TIMES_SECONDS = "300,3600,86400,259200";
        DEFAULT_DOWNLOADS = 1;
        DEFAULT_EXPIRE_SECONDS = 86400;
      };
    };
  };
}
