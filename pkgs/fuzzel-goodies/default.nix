{
  lib,
  stdenv,
  makeWrapper,
  bemoji,
  cliphist,
  fd,
  fish,
  fuzzel,
  jq,
  wl-clipboard,
  wtype,
}:
stdenv.mkDerivation {
  name = "fuzzel-goodies";

  src = ./scripts;

  nativeBuildInputs = [makeWrapper];

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
        bemoji
        cliphist
        fd
        fish
        fuzzel
        jq
        wl-clipboard
        wtype
      ]
    }
    done
  '';
}
