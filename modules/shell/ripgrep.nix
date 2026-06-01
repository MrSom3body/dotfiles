{
  flake.modules.homeManager.shell = {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--hidden"

        "--smart-case"
      ];
    };
  };
}
