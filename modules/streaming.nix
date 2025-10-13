{
  flake.modules.homeManager.streaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        grayjay
        jellyfin-media-player
      ];
    };
}
