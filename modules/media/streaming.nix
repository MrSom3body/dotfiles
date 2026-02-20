{
  flake.modules.homeManager.media =
    { pkgs, ... }:
    {
      home.packages = builtins.attrValues { inherit (pkgs) grayjay tsukimi; };
    };
}
