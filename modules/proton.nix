{
  flake.modules.homeManager.proton =
    { pkgs, ... }:
    {
      home.packages = builtins.attrValues {
        inherit (pkgs)
          proton-authenticator
          proton-pass
          protonvpn-gui
          ;
      };
    };
}
