# copied from @fufexan
{
  lib,
  stdenv,
  makeWrapper,
  fish,
  grim,
  libnotify,
  slurp,
  tesseract,
  wl-clipboard,
}:
stdenv.mkDerivation rec {
  name = "wl-ocr";

  src = ./.;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 $src/${name}.fish $out/bin/${name}
  '';

  fixupPhase = ''
    wrapProgram $out/bin/${name} --set PATH ${
      lib.makeBinPath [
        fish
        grim
        libnotify
        slurp
        tesseract
        wl-clipboard
      ]
    }
  '';

  meta.mainProgram = name;
}
