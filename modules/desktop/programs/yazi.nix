{ lib, ... }: {
  flake.modules.homeManager.desktop = { config, pkgs, ... }: {
    home.packages = [ pkgs.exiftool ];
    programs.yazi = {
      enable = true;
      shellWrapperName = "y";

      settings = {
        mgr = {
          sort_by = "natural";
          sort_dir_first = true;
          show_hidden = false;
          show_symlink = true;
        };

        preview = {
          wrap = "no";
          tab_size = 2;
          max_width = 600;
          max_height = 900;
          image_filter = "triangle";
          image_quality = 75;
          cache_dir = config.xdg.cacheHome;
        };

        # for git plugin
        plugin.prepend_fetchers = [
          {
            id = "git";
            url = "*";
            run = "git";
            group = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
            group = "git";
          }
        ];
      };

      plugins = {
        inherit (pkgs.yaziPlugins)
          chmod
          full-border
          git
          toggle-pane
          mount
          starship
          ;
      };

      initLua = ''
        require("full-border"):setup()
        require("git"):setup {
          order = 1500,
        }
        require("starship"):setup()
      '';

      keymap = {
        mgr.prepend_keymap = [
          {
            # WARN this has never worked for firefox 🥀
            # see https://bugzilla.mozilla.org/show_bug.cgi?id=864052
            on = "y";
            run = [
              ''shell -- for path in %s; do echo "file://$path"; done | ${lib.getExe' pkgs.wl-clipboard "wl-copy"} -t text/uri-list''
              "yank"
            ];
          }
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
            on = [
              "c"
              "m"
            ];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          {
            on = "<C-n>";
            run = ''shell '${lib.getExe pkgs.ripdrag} "$@" -x 2>/dev/null &' --confirm'';
          }
        ];
      };
    };
  };
}
