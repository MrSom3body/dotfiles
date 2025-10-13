{
  flake.modules.homeManager.shell = {
    programs.less.enable = true;
    home.sessionVariables.LESS = "-R";
  };
}
