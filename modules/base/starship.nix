{
  flake.modules.homeManager.homeManager = {
    programs.starship = {
      enable = true;
      settings = {
        shell.disabled = false;
      };
    };
  };
}
