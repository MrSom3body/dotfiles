{ lib, ... }:
let
  name = "touchpad-toggle";
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
          wrapProgram $out/bin/${name} --prefix PATH : ${
            lib.makeBinPath [
              pkgs.coreutils
              pkgs.fish
              pkgs.ripgrep
            ]
          }
        '';

        meta.mainProgram = name;
      };
    };
}
