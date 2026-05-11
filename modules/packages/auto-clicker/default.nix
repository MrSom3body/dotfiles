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
          install -Dm755 $src/${name}.sh $out/bin/${name}
        '';

        fixupPhase = ''
          wrapProgram $out/bin/${name} --prefix PATH : ${
            lib.makeBinPath [
              pkgs.ydotool
            ]
          }
        '';

        meta.mainProgram = name;
      };
    };
}
