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

    # TODO remove when https://github.com/NixOS/nixpkgs/issues/542512 gets resolved
    vesktop = (prev.vesktop.override { electron_40 = prev.electron_42; }).overrideAttrs (oldAttrs: {
      preBuild =
        builtins.replaceStrings [ "exit 1" ] [ "echo 'ignored strict version mismatch'" ]
          oldAttrs.preBuild;
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
