{
  flake.modules.nixos.base = {
    programs.starship = {
      enable = true;
      settings = {
        shell.disabled = false;
      };
    };
  };
}
