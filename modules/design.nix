{
  flake.modules.homeManager.design =
    { pkgs, ... }:
    {
      home.packages = builtins.attrValues {
        inherit (pkgs)
          # images
          inkscape
          krita
          ;
      };
    };
}
