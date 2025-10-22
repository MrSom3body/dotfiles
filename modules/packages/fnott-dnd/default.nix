{ lib, ... }:
let
  name = "fnott-dnd";
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.${name} = pkgs.stdenv.mkDerivation {
        inherit name;

        src = ./.;

        nativeBuildInputs = [ pkgs.makeWrapper ];

        installPhase = ''
          install -Dm755 $src/${name}.fish $out/bin/${name}
        '';

        fixupPhase = ''
          wrapProgram $out/bin/${name} --set PATH ${
            lib.makeBinPath [
              pkgs.coreutils
              pkgs.fish
              pkgs.fnott
              pkgs.libnotify
              pkgs.procps
              pkgs.ripgrep
              pkgs.systemd
            ]
          }
        '';

        meta.mainProgram = name;
      };
    };
}
