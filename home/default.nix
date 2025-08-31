{
  lib,
  config,
  inputs,
  settings,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) types;

  inherit (lib) mkOption;

  cfg = config.my;
in
{
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
    ./shell
    ./sops.nix
    ./stylix.nix
    ./terminal
    ./utilities.nix
    ./xdg.nix

    inputs.som3pkgs.homeManagerModules.power-monitor
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
      shell = {
        enable = true;
      };

      terminal.programs = {
        btop.enable = true;
        git.enable = true;
        gotcha.enable = true;
        gpg.enable = true;
        less.enable = true;
        ssh.enable = true;
        yazi.enable = true;

        bundles = {
          desktop-utils.enable = mkIf (cfg.systemType >= 2) true;
          disk-utils.enable = true;
          networking-utils.enable = true;
        };
      };

      desktop = {
        enable = mkIf (cfg.systemType >= 2) true;
      };

      services.mpris-proxy.enable = mkIf (cfg.systemType >= 2) true;
    };

    programs.home-manager.enable = true;
    services.power-monitor.enable = mkIf (cfg.systemType >= 3) true;
  };
}
