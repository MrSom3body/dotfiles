{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ripdrag];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
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
      plugin.prepend_fetches = [
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
      max-preview = "${inputs.yazi-plugins}/max-preview.yazi";
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
          run = "plugin --sync max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = "<C-n>";
          run = "shell --confirm 'ripdrag \"$@\" -x 2>/dev/null &'";
        }
      ];
    };
  };
}
