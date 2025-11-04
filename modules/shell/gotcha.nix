{ inputs, ... }:
{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.packages = [ inputs.gotcha.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    };
}
