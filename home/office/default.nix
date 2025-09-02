{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (lib) mkEnableOption;
  cfg = config.my.office;
in
{
  imports = [
    ./thunderbird.nix
    ./zathura.nix
  ];

  options.my.office = {
    enable = mkEnableOption "office related programs";
  };

  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        # Documents
        libreoffice-fresh
        simple-scan
        # Notes & Tasks
        obsidian
        todoist-electron
        # Communication
        protonmail-desktop
        ;
    };
  };
}
