{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.emulators.alacritty;
in
{
  options.my.terminal.emulators.alacritty = {
    enable = mkEnableOption "the alacritty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 15;
            y = 15;
          };
          dynamic_padding = true;
        };

        scrolling = {
          history = 10000;
          multiplier = 3;
        };

        selection.save_to_clipboard = true;

        cursor = {
          style = {
            shape = "Beam";
            blinking = "On";
          };
          vi_mode_style = {
            shape = "Block";
            blinking = "On";
          };
        };

        mouse = {
          hide_when_typing = true;
        };
      };
    };
  };
}
