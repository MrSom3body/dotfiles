{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.services.gpg-agent;
in
{
  options.my.services.gpg-agent = {
    enable = mkEnableOption "the gpg-agent service" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
  };
}
