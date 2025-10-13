{ inputs, ... }:
{
  flake.modules.homeManager.shell = {
    imports = [ inputs.nix-index-database.homeModules.nix-index ];
    programs.nix-index-database.comma.enable = true;
  };
}
