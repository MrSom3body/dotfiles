{
  inputs,
  ...
}:
{
  imports = [
    ./browsers
    ./desktop
    ./editors
    ./games
    ./media
    ./office
    ./profiles
    ./programs
    ./school
    ./services
    ./shell
    ./sops.nix
    ./stylix.nix
    ./terminal
    ./utilities.nix
    ./xdg.nix

    inputs.som3pkgs.homeManagerModules.power-monitor
  ];

  config = {
    home = {
      username = "karun";
      homeDirectory = "/home/karun";
      stateVersion = "24.05";
    };
  };
}
