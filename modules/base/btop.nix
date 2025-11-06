{
  flake.modules.homeManager.homeManager = {
    programs.btop = {
      enable = true;

      settings = {
        vim_keys = true;
      };
    };
  };
}
