{
  lib,
  stdenv,
  makeWrapper,
  brightnessctl,
  coreutils,
  fish,
  inotify-tools,
}:
stdenv.mkDerivation rec {
  name = "auto-kbd-bl";

  src = ./.;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 $src/${name}.fish $out/bin/${name}
  '';

  fixupPhase = ''
    wrapProgram $out/bin/${name} --set PATH ${
      lib.makeBinPath [
        brightnessctl
        coreutils
        fish
        inotify-tools
      ]
    }
  '';
}
