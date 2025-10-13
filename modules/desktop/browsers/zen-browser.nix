{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    let
      defaults = import ./_firefoxSettings.nix { inherit pkgs; };
    in
    {
      imports = [ inputs.zen-browser.homeModules.beta ];

      home.sessionVariables = {
        BROWSER = "zen";
      };

      programs.zen-browser = {
        enable = true;
        profiles.default = {
          id = 0;
          name = "default";
          isDefault = true;
          inherit (defaults) settings search;
        };
      };
    };
}
