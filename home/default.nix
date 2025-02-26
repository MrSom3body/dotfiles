{dotfiles, ...}: {
  imports = [
    ./terminal
  ];

  home = {
    username = "karun";
    homeDirectory = "/home/karun";
    stateVersion = "24.05";

    sessionVariables = {
      EDITOR = dotfiles.editor;
      BROWSER = dotfiles.browser;
    };
  };

  programs.home-manager.enable = true;
}
