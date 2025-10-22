{ lib, ... }:
let
  name = "auto-kbd-bl";
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
          install -Dm755 $src/${name}.fish $out/bin/${name}
        '';

        fixupPhase = ''
          wrapProgram $out/bin/${name} --set PATH ${
            lib.makeBinPath [
              pkgs.brightnessctl
              pkgs.coreutils
              pkgs.fish
              pkgs.inotify-tools
            ]
          }
        '';

        meta.mainProgram = name;
      };
    };
}
