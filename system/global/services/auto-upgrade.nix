{ inputs, ... }:
{
  system.autoUpgrade = {
    enable = inputs.self ? rev;
    flake = "github:MrSom3body/dotfiles";
    upgrade = false;
    dates = "03:00";
  };
}
