{
  flake.modules.homeManager.media =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        grayjay
        tsukimi
      ];
    };
}
