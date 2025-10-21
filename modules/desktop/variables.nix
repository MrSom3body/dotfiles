{ config, ... }:
let
  inherit (config.flake.meta) programs;
in
{
  flake.modules.homeManager.desktop = {
    home.sessionVariables = {
      EDITOR = programs.editor;
      BROWSER = programs.browser;
    };
  };
}
