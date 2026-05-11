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
          install -Dm755 $src/${name}.sh $out/bin/${name}
        '';

        fixupPhase = ''
          wrapProgram $out/bin/${name} --prefix PATH : ${
            lib.makeBinPath [
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
