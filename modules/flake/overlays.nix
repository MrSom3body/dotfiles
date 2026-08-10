{ inputs, ... }:
let
  nix-topology = inputs.nix-topology.overlays.default;

  modifications = final: prev: {
    obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/obsidian \
          --prefix PATH : ${final.lib.makeBinPath [ final.pandoc ]}
      '';
    });

    microbin = prev.microbin.overrideAttrs (_oldAttrs: rec {
      version = "2.1.4";
      src = prev.fetchFromGitHub {
        owner = "szabodanika";
        repo = "microbin";
        rev = "v${version}";
        hash = "sha256-ipSMiUJgbZ0kijGs7Ok8bRTGdFzygIPEY6ZuJ/eRb9s=";
      };
      cargoDeps = prev.rustPlatform.fetchCargoVendor {
        inherit src;
        hash = "sha256-vvSQfXu67RNBXzfDIE2rcfUOcAfTACaVRvSBBITJ9gY=";
      };
      patches = [ ];
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
