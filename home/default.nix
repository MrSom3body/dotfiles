{settings, ...}: {
  imports = [
    ./terminal
  ];

  home = {
    username = settings.user;
    homeDirectory = "/home/${settings.user}";
    stateVersion = "24.05";

    sessionVariables = {
      EDITOR = settings.programs.editor;
      BROWSER = settings.programs.browser;
    };
  };

  programs.home-manager.enable = true;
}
