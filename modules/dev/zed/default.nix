{
  flake.modules.homeManager.dev = {
    programs = {
      zed-editor = {
        enable = true;
        userSettings = {
          # appearance
          relative_line_numbers = "enabled";
          buffer_line_height = "standard";
          inlay_hints.enabled = true;
          diagnostics.inline.enabled = true;

          # behaviour
          use_smartcase_search = true;
          load_direnv = "shell_hook";

          # bindings
          base_keymap = "Atom";
          vim_mode = true;

          # ai
          agent = {
            default_model = {
              provider = "copilot_chat";
              model = "claude-opus-4.5";
            };
          };

          telemetry = {
            diagnostics = false;
            metrics = false;
          };
        };
      };

      fish.functions = {
        z = {
          body = "zeditor";
          wraps = "zeditor";
        };
      };

      bash.shellAliases.z = "zeditor";
    };
  };
}
