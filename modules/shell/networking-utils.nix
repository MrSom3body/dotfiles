{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.packages = builtins.attrValues {
        inherit (pkgs)
          dig
          iputils
          nmap
          speedtest-cli
          ;
      };
    };
}
