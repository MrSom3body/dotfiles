{
  services = {
    send = {
      enable = true;
      host = "127.0.0.1";
      port = 1443;
      environment = let
        min = 60;
        hour = min * 60;
        day = hour * 24;
      in {
        MAX_EXPIRE_SECONDS = 3 * day;
        MAX_DOWNLOADS = 50;
        DOWNLOAD_COUNTS = "1,2,3,5,10,25,50";
        EXPIRE_TIMES_SECONDS = builtins.concatStringsSep "," (
          builtins.map builtins.toString [
            (5 * min)
            (1 * hour)
            (1 * day)
            (3 * day)
          ]
        );
        DEFAULT_DOWNLOADS = 1;
        DEFAULT_EXPIRE_SECONDS = 3 * day;
      };
    };
  };
}
