{
  lib,
  stdenv,
  makeWrapper,
  coreutils,
  fish,
  inotify-tools,
  libnotify,
  power-profiles-daemon,
}:
stdenv.mkDerivation {
  name = "power-monitor";

  src = ./.;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 $src/power-monitor.fish $out/bin/power-monitor
  '';

  fixupPhase = ''
    wrapProgram $out/bin/power-monitor --set PATH ${
      lib.makeBinPath [
        coreutils
        fish
        inotify-tools
        libnotify
        power-profiles-daemon
      ]
    }
  '';
}
