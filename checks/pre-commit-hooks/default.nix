{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) pre-commit-hooks;
in
  pre-commit-hooks.lib.${pkgs.system}.run {
    src = ./.;
    hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      markdownlint = {
        enable = true;
        settings.configuration.MD013.tables = false;
      };
      nil.enable = true;
      statix.enable = true;
    };
  }
