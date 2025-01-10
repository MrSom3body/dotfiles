{
  pkgs,
  dotfiles,
  ...
}: let
  foot-pipe = pkgs.writeScript "foot-pipe" ''
    #!${pkgs.fish}/bin/fish
    set tmp (mktemp)
    cat > $tmp
    ${dotfiles.terminal} ${dotfiles.editor} -- $tmp
    rm -f -- $tmp
  '';
in {
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
        pipe-command-output = "[${foot-pipe}] Control+Shift+g";
      };

      mouse.hide-when-typing = "yes";

      scrollback = {
        lines = 10000;
        indicator-format = "line";
      };
    };
  };

  programs.fish.shellInit =
    # fish
    ''
      # Jumping between prompts
      function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
      end

      # Piping last command's output
      function foot_cmd_start --on-event fish_preexec
        echo -en "\e]133;C\e\\"
      end

      function foot_cmd_end --on-event fish_postexec
        echo -en "\e]133;D\e\\"
      end
    '';
}
