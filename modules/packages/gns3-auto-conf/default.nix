{ lib, ... }:
let
  name = "gns3-auto-conf";
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
            pkgs.coreutils
            pkgs.fzf
            pkgs.jq
          ]
        }
      '';

      meta.mainProgram = name;
    };
  };
}
