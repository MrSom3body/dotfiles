{
  flake.modules.homeManager.dev = {
    programs.zed-editor = {
      enable = true;
      extensions = [ "nix" ];
      userSettings = {
        agent = {
          default_model = {
            provider = "copilot_chat";
            model = "claude-opus-4.5";
          };
        };
        helix_mode = true;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        base_keymap = "Atom";
        load_direnv = "shell_hook";
      };
    };
  };
}
