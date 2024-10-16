{
  config,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;

    font = {
      inherit (config.stylix.fonts.monospace) name;
      size = config.stylix.fonts.sizes.terminal;
    };

    settings = {
      background_opacity = lib.mkForce 1;
      touch_scroll_multiplier = "5.0";
      window_padding_width = 20;
    };

    keybindings = {
      "ctrl+shift+t" = "new_tab_with_cwd";
    };
  };

  home.shellAliases = {
    icat = "kitten icat";
  };
}
