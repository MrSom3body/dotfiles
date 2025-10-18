{
  flake.modules.homeManager.terraform =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.terraform ];
    };
}
