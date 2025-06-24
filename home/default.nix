{settings, ...}: {
  imports = [
    ./browsers
    ./editors
    ./games
    ./media
    ./office
    ./programs
    ./sops.nix
    ./terminal
    ./utilities.nix
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
