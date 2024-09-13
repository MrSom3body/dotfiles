{
  pkgs,
  lib,
  config,
  dotfiles,
  ...
}: {
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      shfmt
      stylua

      cargo
      gcc
      lazygit
      nodejs
    ];
  };

  home = {
    file.".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink /.${dotfiles.path}/home/editors/nvim/configs;
      recursive = false;
    };

    activation = {
      changeNvimTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
        echo base16-${dotfiles.theme} > ~/.local/share/nvim/colorsaver
      '';
    };

    shellAliases = {
      n = "nvim";
      nv = "nvim";
    };
  };
}
