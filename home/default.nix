{settings, ...}: {
  imports = [
    ./sops.nix
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
