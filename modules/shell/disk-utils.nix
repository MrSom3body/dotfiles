{
  flake.modules.homeManager.shell = { pkgs, ... }: {
    home.packages = builtins.attrValues { inherit (pkgs) dua sd; };
  };
}
