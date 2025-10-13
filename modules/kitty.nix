{
  flake.modules.homeManager.kitty = {
    programs.kitty = {
      enable = true;

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
