{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    let
      defaults = import ./_firefoxSettings.nix { inherit pkgs; };
    in
    {
      imports = [ inputs.zen-browser.homeModules.beta ];

      programs.zen-browser = {
        enable = true;
        suppressXdgMigrationWarning = true;
        profiles.default = {
          id = 0;
          name = "default";
          isDefault = true;
          inherit (defaults) settings search;
        };
      };
    };
}
