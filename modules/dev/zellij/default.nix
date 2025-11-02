{
  flake.modules.homeManager.dev = {
    programs.zellij = {
      enable = true;
      settings = {
        default_mode = "locked";
      };
      extraConfig = builtins.readFile ./binds.kdl;
    };
  };
}
