{
  flake.modules.homeManager.messaging =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.element-desktop ];
    };
}
