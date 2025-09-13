{
  lib,
  settings,
  ...
}:
let
  inherit (lib) types;
  inherit (lib) mkOption;
in
{
  imports = [
    ./workstation.nix
    ./laptop.nix
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
    home.sessionVariables = {
      EDITOR = settings.programs.editor;
      BROWSER = settings.programs.browser;
    };

    programs.home-manager.enable = true;

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
          disk-utils.enable = true;
          networking-utils.enable = true;
        };
      };
    };
  };
}
