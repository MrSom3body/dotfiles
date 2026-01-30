{
  flake.modules.homeManager.dev = {
    programs = {
      zed-editor = {
        enable = true;
        mutableUserKeymaps = false;
        userSettings = {
          # appearance
          tabs = {
            file_icons = true;
            git_status = true;
          };
          relative_line_numbers = "enabled";
          buffer_line_height = "standard";
          inlay_hints.enabled = true;
          diagnostics.inline.enabled = true;

          # behaviour
          use_smartcase_search = true;
          load_direnv = "shell_hook";

          # bindings
          base_keymap = "VSCode";
          vim_mode = true;
          which_key = {
            enabled = true;
            delay_ms = 0;
          };

          # terminal
          terminal = {
            env = {
              EDITOR = "zeditor --wait";
            };
          };

          # multiplayer
          calls = {
            mute_on_join = true;
          };

          # ai
          show_edit_predictions = true;
          edit_predictions.mode = "subtle";
          agent = {
            default_model = {
              provider = "copilot_chat";
              model = "gpt-5.2-codex";
            };
          };

          telemetry = {
            diagnostics = true;
            metrics = true;
          };
        };
        userKeymaps = [
          {
            context = "Workspace";
            bindings = {
              "shift shift" = "file_finder::Toggle";
            };
          }
        ];
      };

      fish.functions = {
        z = {
          body = "zeditor $argv";
          wraps = "zeditor";
        };
      };

      bash.shellAliases.z = "zeditor";
    };
  };
}
