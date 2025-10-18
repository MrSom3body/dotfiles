{ inputs, ... }:
{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.packages = [ inputs.gotcha.packages.${pkgs.system}.default ];
    };
}
