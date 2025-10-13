{
  flake.modules.homeManager.shell = {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--max-columns=150"
        "--max-columns-preview"

        "--hidden"

        "--smart-case"
      ];
    };
  };
}
