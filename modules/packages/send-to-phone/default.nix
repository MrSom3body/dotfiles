{ lib, ... }:
let
  name = "send-to-phone";
in
{
  perSystem = { pkgs, ... }: {
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
            pkgs.bash
            pkgs.kdePackages.kdeconnect-kde
            pkgs.fzf
            pkgs.gawk
            pkgs.coreutils
            pkgs.gnugrep
          ]
        }
      '';

      meta.mainProgram = name;
    };
  };
}
