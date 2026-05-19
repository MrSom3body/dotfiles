{
  flake.modules.homeManager.homeManager = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "som3box" = {
          Hostname = "u564683.your-storagebox.de";
          User = "u564683";
          Port = 23;
        };

        "*" = {
          ForwardAgent = false;
          AddKeysToAgent = "no";
          Compression = false;
          ServerAliveInterval = 60;
          ServerAliveCountMax = 3;
          HashKnownHosts = true;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "30m";
          SetEnv = {
            TERM = "xterm-256color";
          };
        };
      };
    };
  };
}
