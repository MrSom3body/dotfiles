{
  lib,
  config,
  pkgs,
  settings,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib) mkIf;

  cfg = config.my.terminal.emulators.foot;

  foot-pipe = pkgs.writeScript "foot-pipe" ''
    #!${pkgs.fish}/bin/fish
    set tmp (mktemp)
    cat > $tmp
    ${settings.programs.terminal} ${settings.programs.editor} -- $tmp
    rm -f -- $tmp
  '';
in
{
  options.my.terminal.emulators.foot = {
    enable = mkEnableOption "the foot terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;

      server.enable = if settings.programs.terminal == "footclient" then true else false;

      settings = {
        main = {
          pad = "15x15 center";
          # changes the background color -> makes it not match waybar anymore 😥
          gamma-correct-blending = false;
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
  };
}
