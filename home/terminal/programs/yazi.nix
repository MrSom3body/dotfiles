{pkgs, ...}: let
  plugins-repo = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "39f275382e5087610ba97312eaa5f7d10286302f";
    sha256 = "sha256-KSqL25o82PLHSLx1Pw+Ump9GPoebNaNtC9uoAxKifmI=";
  };
in {
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
    };

    plugins = {
      chmod = "${plugins-repo}/chmod.yazi";
      full-border = "${plugins-repo}/full-border.yazi";
      max-preview = "${plugins-repo}/max-preview.yazi";
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "5abe29e7750eb98d5a3554925a7d8c242bd9f96d";
        sha256 = "sha256-jFqMD2GZm3rjLdCL4Wl0xuG5AnaiBgusBYKt5AopQGE=";
      };
    };

    initLua = ''
      require("full-border"):setup()
      require("starship"):setup()
    '';

    keymap = {
      manager.prepend_keymap = [
        {
          on = "T";
          run = "plugin --sync max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = [
            "c"
            "m"
          ];
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
