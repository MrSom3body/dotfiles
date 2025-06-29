{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.programs.yazi;
in {
  options.my.programs.yazi = {
    enable = mkEnableOption "yazi";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      package = inputs.yazi.packages.${pkgs.system}.default;
      shellWrapperName = "y";

      settings = {
        manager = {
          show_hidden = false;
        };
        preview = {
          max_width = 1000;
          max_height = 1000;
        };
        # for git plugin
        plugin.prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
      };

      plugins = {
        chmod = "${inputs.yazi-plugins}/chmod.yazi";
        full-border = "${inputs.yazi-plugins}/full-border.yazi";
        git = "${inputs.yazi-plugins}/git.yazi";
        toggle-pane = "${inputs.yazi-plugins}/toggle-pane.yazi";
        mount = "${inputs.yazi-plugins}/mount.yazi";
        starship = "${inputs.yazi-starship-plugin}";
      };

      initLua = ''
        require("full-border"):setup()
        require("git"):setup()
        require("starship"):setup()
      '';

      keymap = {
        manager.prepend_keymap = [
          {
            on = "M";
            run = "plugin mount";
            desc = "Open mount";
          }
          {
            on = "T";
            run = "plugin toggle-pane max-preview";
            desc = "Maximize or restore the preview pane";
          }
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          {
            on = "<C-n>";
            run = "shell --confirm '${lib.getExe pkgs.ripdrag} \"$@\" -x 2>/dev/null &'";
          }
        ];
      };
    };
  };
}
