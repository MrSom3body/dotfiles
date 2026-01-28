{ config, ... }:
let
  inherit (config.flake.meta) programs;
in
{
  flake.modules = {
    nixos.desktop = {
      # tell Electron/Chromium to run on Wayland
      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };

    homeManager.desktop = {
      home.sessionVariables = {
        EDITOR = programs.editor;
        BROWSER = programs.browser;
      };
    };
  };
}
