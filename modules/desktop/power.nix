{ lib, ... }:
{
  flake.modules.nixos.desktop = {
    services = {
      tuned = {
        enable = true;
        profiles = {
          panel_power_savings.video.panel_power_savings = 0; # makes colors look washed out
        };
      };
      tlp.enable = lib.mkForce false;

      upower.enable = true;
    };

    environment.etc = {
      "tuned/post_loaded_profile".text = "panel_power_savings";
    };
  };
}
