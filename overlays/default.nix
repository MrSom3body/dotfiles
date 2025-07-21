{inputs, ...}: {
  modifications = final: prev: let
    nixpkgs-jetbrains =
      import (builtins.fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/42a1c966be226125b48c384171c44c651c236c22.tar.gz";
        sha256 = "sha256:082dpl311xlspwm5l3h2hf10ww6l59m7k2g2hdrqs4kwwsj9x6mf";
      }) {
        inherit (final.pkgs) system;
        config.allowUnfree = true;
      };
  in {
    bemoji = prev.bemoji.overrideAttrs (_oldAttrs: {
      version = "unstable-2025-03-17";
      src = final.fetchFromGitHub {
        owner = "marty-oehme";
        repo = "bemoji";
        rev = "1b5e9c1284ede59d771bfd43780cc8f6f7446f38";
        hash = "sha256-WD4oFq0NRZ0Dt/YamutM7iWz3fMRxCqwgRn/rcUsTIw=";
      };
    });

    obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
      postInstall =
        (oldAttrs.postInstall or "")
        + ''
          wrapProgram $out/bin/obsidian \
            --prefix PATH : ${final.lib.makeBinPath [final.pandoc]}
        '';
    });

    # TODO delete when https://github.com/NixOS/nixpkgs/issues/400317 gets resolved
    inherit (nixpkgs-jetbrains) jetbrains;

    # TODO delete when https://github.com/NixOS/nixpkgs/issues/425323 gets resolved
    jdk8 = final.temurin-bin-8;
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
