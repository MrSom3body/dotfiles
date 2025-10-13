{
  flake.modules.homeManager.shell = {
    programs.fd = {
      enable = true;
      hidden = false;
      ignores = [
        ".git/"
        "venv/"
      ];
    };
  };
}
