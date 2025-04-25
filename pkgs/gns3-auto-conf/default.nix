{
  lib,
  stdenv,
  makeWrapper,
  coreutils,
  fish,
  fzf,
  jq,
}:
stdenv.mkDerivation rec {
  name = "gns3-auto-conf";

  src = ./.;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 $src/${name}.fish $out/bin/${name}
  '';

  fixupPhase = ''
    wrapProgram $out/bin/${name} --set PATH ${
      lib.makeBinPath [
        coreutils
        fish
        fzf
        jq
      ]
    }
  '';

  meta.mainProgram = name;
}
