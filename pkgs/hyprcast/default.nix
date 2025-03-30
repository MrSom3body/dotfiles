{
  lib,
  stdenv,
  makeWrapper,
  coreutils,
  fish,
  libnotify,
  procps,
  wireplumber,
  wl-screenrec,
}:
stdenv.mkDerivation {
  pname = "hyprcast";
  version = "2.0.1";

  src = ./.;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 $src/hyprcast.fish $out/bin/hyprcast
  '';

  fixupPhase = ''
    wrapProgram $out/bin/hyprcast --set PATH ${
      lib.makeBinPath [
        coreutils
        fish
        libnotify
        procps
        wireplumber
        wl-screenrec
      ]
    }
  '';
}
