{
  lib,
  config,
  settings,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) types;

  inherit (lib) mkOption;

  cfg = config.my;
in {
  imports = [
    ./browsers
    ./desktop
    ./editors
    ./games
    ./media
    ./office
    ./programs
    ./school.nix
    ./services
    ./sops.nix
    ./stylix.nix
    ./terminal
    ./utilities.nix
  ];

  options.my.systemType = mkOption {
    type = types.addCheck types.int (x: x >= 0 && x <= 3);
    default = 1;
    description = ''
      Switch between a system profile:
      - 0 -> iso
      - 1 -> server
      - 2 -> workstation
      - 3 -> laptop
    '';
  };

  config = {
    home = {
      username = "karun";
      homeDirectory = "/home/karun";
      stateVersion = "24.05";

      sessionVariables = {
        EDITOR = settings.programs.editor;
        BROWSER = settings.programs.browser;
      };
    };

    my = {
      desktop = {
        enable = mkIf (cfg.systemType >= 2) true;
      };
      services.power-monitor.enable = mkIf (cfg.systemType >= 3) true;
    };

    programs.home-manager.enable = true;
  };
}
