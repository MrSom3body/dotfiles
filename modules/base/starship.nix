{
  flake.modules.homeManager.base = {
    programs.starship = {
      enable = true;
      settings = {
        shell.disabled = false;
      };
    };
  };
}
