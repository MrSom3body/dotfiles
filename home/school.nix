{
  lib,
  config,
  inputs,
  pkgs,
  preFetch,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;

  cfg = config.my.school;
in
{
  options.my.school = {
    enable = mkEnableOption "school related programs";
  };

  config = mkIf cfg.enable {
    home.packages =
      let
        plugins = [
          "github-copilot"
          "ideavim"
          "mermaid"
        ];
      in
      builtins.attrValues {
        inherit (pkgs)
          # IDEs
          jetbrains-toolbox
          # JDKs
          temurin-bin
          # Other thingies
          anki-bin
          openfortivpn
          vpnc
          ;
      }
      ++ [
        (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.datagrip plugins)
        (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate plugins)
        (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.phpstorm plugins)
      ]
      ++ (
        if preFetch then
          [
            # pkgs.ciscoPacketTracer8
          ]
        else
          [ ]
      );

    xdg.configFile."ideavim/ideavimrc".text = ''
      source ${inputs.helix-vim}/src/helix.idea.vim
    '';
  };
}
