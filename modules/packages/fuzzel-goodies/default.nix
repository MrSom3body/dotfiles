{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.fuzzel-goodies = pkgs.stdenv.mkDerivation {
        name = "fuzzel-goodies";

        src = ./scripts;

        nativeBuildInputs = [ pkgs.makeWrapper ];

        installPhase = ''
          mkdir -p $out/bin
          for script in $src/*; do
            install -Dm755 "$script" "$out/bin/$(basename -s .sh $script)"
          done
        '';

        fixupPhase = ''
          for script in $out/bin/*; do
            wrapProgram "$script" --prefix PATH : ${
              lib.makeBinPath [
                pkgs.bemoji
                pkgs.cliphist
                pkgs.fd
                pkgs.fuzzel
                pkgs.jq
                pkgs.procps
                pkgs.wl-clipboard
                pkgs.wtype
                pkgs.xdg-utils
              ]
            }
          done
        '';
      };
    };
}
