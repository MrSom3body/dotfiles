{
  flake.modules.homeManager.school =
    { pkgs, ... }:
    {
      home.packages = builtins.attrValues { inherit (pkgs) openfortivpn vpnc; };
    };
}
