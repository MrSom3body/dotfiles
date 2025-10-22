{ lib, ... }:
let
  name = "hyprcast";
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
              pkgs.libnotify
              pkgs.procps
              pkgs.wireplumber
              pkgs.wl-screenrec
            ]
          }
        '';

        meta.mainProgram = name;
      };
    };
}
