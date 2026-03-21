{
  flake.modules.homeManager.homeManager = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "som3box" = {
          hostname = "u564683.your-storagebox.de";
          user = "u564683";
          port = 23;
        };

        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 60;
          serverAliveCountMax = 3;
          hashKnownHosts = true;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "auto";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "30m";
          setEnv = {
            TERM = "xterm-256color";
          };
        };
      };
    };
  };
}
