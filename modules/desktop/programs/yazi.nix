{ lib, ... }:
{
  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    {
      home.packages = [ pkgs.exiftool ];
      programs = {
        fish.functions = {
          yy = {
            body = "yazi";
            wraps = "yazi";
          };
        };

        bash.shellAliases = {
          yy = "yazi";
        };

        yazi = {
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
            require("git"):setup()
            require("starship"):setup()
          '';

          keymap = {
            mgr.prepend_keymap = [
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
    };
}
