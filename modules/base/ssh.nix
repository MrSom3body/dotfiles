{
  flake.modules.homeManager.homeManager = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "lbt" = {
          hostname = "lbt.tail7807a4.ts.net";
        };

        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
          setEnv = {
            TERM = "xterm-256color";
          };
        };
      };
    };
  };
}
