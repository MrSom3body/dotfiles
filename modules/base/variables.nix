{ lib, config, ... }:
let
  inherit (config.flake.meta) programs;
in
{
  flake.modules.nixos.nixos = {
    home.sessionVariables = {
      EDITOR = lib.mkDefault programs.editor;
      BROWSER = lib.mkDefault "echo";
    };
  };
}
