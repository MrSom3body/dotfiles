{
  flake.modules.homeManager.messaging =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.signal-desktop-bin ];
    };
}
