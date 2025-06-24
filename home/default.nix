{settings, ...}: {
  imports = [
    ./sops.nix
    ./browsers
    ./editors
    ./games
    ./media
    ./terminal
  ];

  home = {
    username = "karun";
    homeDirectory = "/home/karun";
    stateVersion = "24.05";

    sessionVariables = {
      EDITOR = settings.programs.editor;
      BROWSER = settings.programs.browser;
    };
  };

  programs.home-manager.enable = true;
}
