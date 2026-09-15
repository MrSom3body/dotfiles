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

    # TODO remove when https://github.com/nixos/nixpkgs/issues/562919 gets resolved
    linux-firmware = prev.linux-firmware.overrideAttrs {
      version = "20260810";
      src = final.fetchFromGitLab {
        owner = "kernel-firmware";
        repo = "linux-firmware";
        tag = "20260810";
        hash = "sha256-P/fPpqaatp8Z2GV+I/OChiWGn6AhV+8w1RMFuX/LqHc=";
      };
    };

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
