{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        pad = "15x15 center";
      };

      bell = {
        urgent = "yes";
        notify = "yes";
      };

      scrollback = {
        lines = 10000;
        indicator-format = "line";
      };

      cursor = {
        style = "beam";
        unfocused-style = "hollow";
        blink = "yes";
      };

      mouse.hide-when-typing = "yes";
    };
  };
}
