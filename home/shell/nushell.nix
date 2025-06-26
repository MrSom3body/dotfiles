{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;

  inherit (lib) mkEnableOption;
  cfg = config.my.shell.nushell;
in {
  options.my.shell.nushell = {
    enable = mkEnableOption "my nushell shell";
  };

  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      settings = {
        show_banner = false;
        rm.always_trash = true;

        edit_mode = "vi";
        cursor_shape.vi_insert = "line";
        cursor_shape.vi_normal = "block";

        datetime_format.normal = "%d.%m.%y %I:%M:%S%p";
        filesize.unit = "binary";
      };

      environmentVariables = {
        PROMPT_INDICATOR_VI_INSERT = "";
        PROMPT_INDICATOR_VI_NORMAL = "";
      };

      extraConfig = ''
        if $nu.is-interactive {
          gotcha
        }
      '';
    };
  };
}
