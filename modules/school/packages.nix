{
  flake.modules.homeManager.school =
    { pkgs, ... }:
    {
      home.packages = builtins.attrValues {
        inherit (pkgs)
          anki-bin
          openfortivpn
          vpnc
          ;
      };
    };
}
