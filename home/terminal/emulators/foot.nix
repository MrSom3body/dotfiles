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

  programs.fish.functions = {
    # Jumping between prompts
    mark_prompt_start = {
      onEvent = "fish_prompt";
      body = ''
        echo -en "\e]133;A\e\\"
      '';
    };

    # Piping last command's output
    foot_cmd_start = {
      onEvent = "fish_preexec";
      body = ''
        echo -en "\e]133;C\e\\"
      '';
    };

    foot_cmd_end = {
      onEvent = "fish_postexec";
      body = ''
        echo -en "\e]133;D\e\\"
      '';
    };
  };
}
