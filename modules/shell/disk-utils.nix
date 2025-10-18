{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      xdg.configFile."dust/config.toml".text =
        # toml
        ''
          reverse=false
        '';

      home.packages = builtins.attrValues {
        inherit (pkgs)
          dust
          sd
          ;
      };
    };
}
