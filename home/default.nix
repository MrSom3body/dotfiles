{dotfiles, ...}: {
  imports = [
    ./terminal
  ];

  home = {
    username = dotfiles.user;
    homeDirectory = "/home/${dotfiles.user}";
    stateVersion = "24.05";

    sessionVariables = {
      EDITOR = dotfiles.programs.editor;
      BROWSER = dotfiles.programs.browser;
    };
  };

  programs.home-manager.enable = true;
}
