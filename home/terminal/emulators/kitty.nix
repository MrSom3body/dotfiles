{
  config,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      name = config.stylix.fonts.monospace.name;
      size = config.stylix.fonts.sizes.terminal;
    };
    shellIntegration = {
      mode = "no-sudo";
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    settings = {
      background_opacity = lib.mkForce 1;
      touch_scroll_multiplier = "5.0";
      window_padding_width = 20;
    };
  };

  home.shellAliases = {
    icat = "kitten icat";
  };
}