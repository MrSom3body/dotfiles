{ lib, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      services.playerctld.enable = true;

      systemd.user.services.playerctld.Service.Restart = lib.mkForce "on-failure";

      home.packages = [ pkgs.playerctl ];
    };
}
