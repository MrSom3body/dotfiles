{
  flake.modules.homeManager.shell = {
    programs.jq = {
      enable = true;
    };
  };
}
