{
  flake.modules.nixos.nixos.networking.stevenblack = {
    enable = true;
    block = [
      "fakenews"
      "gambling"
      "porn"
      # "social"
    ];
  };
}
