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
            install -Dm755 "$script" "$out/bin/$(basename -s .fish $script)"
          done
        '';

        fixupPhase = ''
          for script in $out/bin/*; do
            wrapProgram "$script" --prefix PATH : ${
              lib.makeBinPath [
                pkgs.bemoji
                pkgs.cliphist
                pkgs.fd
                pkgs.fish
                pkgs.fuzzel
                pkgs.jq
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
