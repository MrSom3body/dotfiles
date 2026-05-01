{ lib, ... }:
let
  name = "waybar-khal-events";
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.${name} = pkgs.stdenv.mkDerivation {
        inherit name;

        src = ./.;

        nativeBuildInputs = [ pkgs.makeWrapper ];

        installPhase = ''
          install -Dm755 $src/${name}.sh $out/bin/${name}
        '';

        fixupPhase = ''
          wrapProgram $out/bin/${name} --set PATH ${
            lib.makeBinPath [
              pkgs.bash
              pkgs.khal
              pkgs.coreutils
              pkgs.util-linux
              pkgs.inotify-tools
              pkgs.jq
            ]
          }
        '';

        meta.mainProgram = name;
      };
    };
}
