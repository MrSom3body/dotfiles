# copied from @fufexan
{ lib, ... }:
let
  name = "wl-ocr";
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
              pkgs.fish
              pkgs.grim
              pkgs.libnotify
              pkgs.slurp
              pkgs.tesseract
              pkgs.wl-clipboard
            ]
          }
        '';

        meta.mainProgram = name;
      };
    };
}
