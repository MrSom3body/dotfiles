{dotfiles, ...}: {
  imports = [
    ./gtk.nix
    ./terminal
  ];

  home = {
    username = dotfiles.username;
    homeDirectory = "/home/${dotfiles.username}";
    stateVersion = "24.05";

    sessionVariables = {
      EDITOR = dotfiles.editor;
      BROWSER = dotfiles.browser;
    };
  };

  programs.home-manager.enable = true;
}
