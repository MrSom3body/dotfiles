{
  flake.modules.homeManager.proton =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        proton-authenticator
        proton-pass
        protonvpn-gui
      ];
    };
}
