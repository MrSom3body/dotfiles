{
  perSystem =
    { lib, pkgs, ... }:
    let
      name = "auto-clicker";
    in
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
              pkgs.fish
              pkgs.ydotool
            ]
          }
        '';

        meta.mainProgram = name;
      };
    };
}
