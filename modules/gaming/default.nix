{
  flake.modules = {
    nixos.gaming = {
      boot.kernelModules = [ "ntsync" ];
    };

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
