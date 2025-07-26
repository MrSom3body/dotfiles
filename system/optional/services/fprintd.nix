{ pkgs, ... }:
{
  services.fprintd = {
    enable = true;
    tod = {
      enable = false;
      driver = pkgs.libfprint-2-tod1-elan;
    };
  };
}
