{
  flake.modules.homeManager.school =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.ciscoPacketTracer8
      ];
    };
}
