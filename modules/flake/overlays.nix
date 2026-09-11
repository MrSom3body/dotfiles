{ inputs, ... }:
let
  nix-topology = inputs.nix-topology.overlays.default;

  modifications = final: prev: {
    # TODO remove when https://github.com/NixOS/nixpkgs/pull/558436 gets merged
    tsukimi = prev.tsukimi.overrideAttrs (
      finalAttrs: previousAttrs: {
        version = "26.9.1";
        src = prev.fetchFromGitHub {
          owner = "tsukinaha";
          repo = "tsukimi";
          tag = "v${finalAttrs.version}";
          hash = "sha256-YhagPMD5nSzLCWQc+LjStezMvzapxw+an1pxN2AdZPM=";
        };
        cargoDeps = prev.rustPlatform.fetchCargoVendor {
          inherit (finalAttrs) pname version src;
          hash = "sha256-EQyG2ZSAHP5Tc6WSWyNa950en4SX+kbzgUUKeVnAswg=";
        };
        nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
          prev.blueprint-compiler
          prev.libglycin.patchVendorHook
        ];
        buildInputs = previousAttrs.buildInputs ++ [
          prev.libglycin
          prev.glycin-loaders
        ];
      }
    );

    obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/obsidian \
          --prefix PATH : ${final.lib.makeBinPath [ final.pandoc ]}
      '';
    });
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  };
in
{
  flake.overlays = {
    default = inputs.nixpkgs.lib.composeManyExtensions [
      nix-topology
      modifications
      stable-packages
    ];

    inherit nix-topology modifications stable-packages;
  };
}
