{dotfiles, ...}: {
  programs.foot = {
    enable = true;

    server.enable =
      if dotfiles.terminal == "footclient"
      then true
      else false;

    settings = {
      main = {
        pad = "15x15 center";
      };

      bell = {
        urgent = "yes";
        notify = "yes";
      };

      cursor = {
        style = "beam";
        unfocused-style = "hollow";
        blink = "yes";
      };

      key-bindings = {
        pipe-command-output = "[sh -c \"bat --paging always -\"] Control+Shift+g";
      };

      mouse.hide-when-typing = "yes";

      scrollback = {
        lines = 10000;
        indicator-format = "line";
      };
    };
  };
}
