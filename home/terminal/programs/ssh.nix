{
  programs.ssh = {
    enable = true;
    matchBlocks."*" = {
      setEnv = {TERM = "xterm-256color";};
    };
  };
}
