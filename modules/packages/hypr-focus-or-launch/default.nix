{ lib, ... }: {
  perSystem = { pkgs, ... }: {
    packages.hypr-focus-or-launch = pkgs.stdenv.mkDerivation {
      name = "hypr-focus-or-launch";

      src = ./scripts;

      nativeBuildInputs = [ pkgs.makeWrapper ];

      installPhase = ''
        mkdir -p $out/bin
        for script in $src/*; do
          install -Dm755 "$script" "$out/bin/$(basename -s .sh $script)"
        done
      '';

      fixupPhase = ''
        for script in $out/bin/*; do
          wrapProgram "$script" --prefix PATH : ${
            lib.makeBinPath [
              pkgs.hyprland
              pkgs.jq
            ]
          }
        done
      '';
    };
  };
}
