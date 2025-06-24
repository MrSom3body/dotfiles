{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;

  inherit (lib) mkEnableOption;
  cfg = config.my.office.mail;
in {
  options.my.office.mail = {
    enable = mkEnableOption "the thunderbird program";
  };

  config = mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles = {
        default = {
          isDefault = true;
          search = {
            default = "ddg";
            privateDefault = "ddg";
          };
        };
      };
    };
  };
}
