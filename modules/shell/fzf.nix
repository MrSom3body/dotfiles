{
  flake.modules.homeManager.shell = {
    programs.fzf = {
      enable = true;
      historyWidget.fish.command = "";
      historyWidget.bash.command = "";
    };
  };
}
