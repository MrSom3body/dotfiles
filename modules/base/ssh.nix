{
  flake.modules.homeManager.homeManager = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
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
