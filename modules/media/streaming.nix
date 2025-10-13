{
  flake.modules.homeManager.media =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        grayjay
        jellyfin-media-player
      ];
    };
}
