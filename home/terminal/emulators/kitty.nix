{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.emulators.kitty;
in
{
  options.my.terminal.emulators.kitty = {
    enable = mkEnableOption "the kitty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      font = {
        inherit (config.stylix.fonts.monospace) name;
        size = config.stylix.fonts.sizes.terminal;
      };

      settings = {
        touch_scroll_multiplier = "5.0";
        window_padding_width = 20;
      };

      keybindings = {
        "ctrl+shift+t" = "new_tab_with_cwd";
      };
    };
  };
}
