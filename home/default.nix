{dotfiles, ...}: {
  imports = [
    ./terminal
  ];

  home = {
    username = dotfiles.user;
    homeDirectory = "/home/${dotfiles.user}";
    stateVersion = "24.05";

    sessionVariables = {
      EDITOR = dotfiles.editor;
      BROWSER = dotfiles.browser;
    };
  };

  programs.home-manager.enable = true;
}
