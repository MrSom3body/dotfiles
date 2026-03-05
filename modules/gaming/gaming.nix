{
  flake.modules = {

    homeManager.gaming =
      { pkgs, ... }:
      {
        home.packages = builtins.attrValues {
          inherit (pkgs)
            goverlay
            heroic
            # mindustry-wayland
            modrinth-app
            r2modman
            ;
        };
      };
  };
}
