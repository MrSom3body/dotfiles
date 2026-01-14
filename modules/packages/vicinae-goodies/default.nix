{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.vicinae-goodies = pkgs.stdenv.mkDerivation {
        name = "vicinae-goodies";

        src = ./scripts;

        nativeBuildInputs = [ pkgs.makeWrapper ];

        installPhase = ''
          mkdir -p $out/bin
          for script in $src/*; do
            install -Dm755 "$script" "$out/bin/$(basename -s .fish $script)"
          done
        '';

        fixupPhase = ''
          for script in $out/bin/*; do
            wrapProgram "$script" --prefix PATH : ${
              lib.makeBinPath [
                pkgs.fish
                pkgs.jq
                pkgs.procps
                pkgs.vicinae
              ]
            }
          done
        '';
      };
    };
}
