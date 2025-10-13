{ inputs, ... }:
{
  flake.modules.homeManager.desktop = {
    imports = [ inputs.tailray.homeManagerModules.default ];
    services.tailray.enable = true;
  };
}
