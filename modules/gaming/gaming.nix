{
  flake.modules = {

    homeManager.gaming =
      { pkgs, ... }:
      {
        home.packages =
          builtins.attrValues {
            inherit (pkgs)
              goverlay
              heroic
              # mindustry-wayland
              # modrinth-app
              r2modman
              ;
          }
          ++ [ pkgs.stable.modrinth-app ]; # TODO remove when https://nixpkgs-tracker.ocfox.me/?pr=485074 lands in nixos-unstable
      };
  };
}
