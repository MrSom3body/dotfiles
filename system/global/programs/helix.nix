{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.helix ];
  programs.nano.enable = false; # eww
}
