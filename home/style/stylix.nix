{lib, ...}: {
  stylix = {
    autoEnable = false;
    targets = {
      bat.enable = true;
      btop.enable = true;
      firefox.enable = true;
      fzf.enable = true;
      gtk.enable = true;
      gnome.enable = true;
      helix.enable = true;
      hyprland.enable = true;
      kde.enable = true;
      kitty = {
        enable = true;
        variant256Colors = true;
      };
      lazygit.enable = true;
      mangohud.enable = true;
      rofi.enable = false; # I have a custom rofi theme
      vesktop.enable = true;
      vim.enable = true;
      waybar.enable = false; # I have a custom waybar theme
      yazi.enable = true;
    };
  };
}
