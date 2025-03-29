{
  lib,
  stdenv,
  makeWrapper,
  fish,
  libnotify,
  wl-screenrec,
  procps,
}:
stdenv.mkDerivation {
  pname = "hyprcast";
  version = "2.0.0";

  src = ./.;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 $src/hyprcast.fish $out/bin/hyprcast
  '';

  postInstall = ''
    wrapProgram $out/bin/hyprcast --set PATH ${
      lib.makeBinPath [
        fish
        libnotify
        wl-screenrec
        procps
      ]
    }
  '';
}
