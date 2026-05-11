{ lib, ... }:
let
  name = "power-monitor";
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
          wrapProgram $out/bin/${name} --prefix PATH : ${
            lib.makeBinPath [
              pkgs.coreutils
              pkgs.inotify-tools
              pkgs.libnotify
              pkgs.power-profiles-daemon
            ]
          }
        '';

        meta.mainProgram = name;
      };
    };
}
