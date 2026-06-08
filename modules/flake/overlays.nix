{ inputs, ... }: {
  flake.overlays = rec {
    default = inputs.nixpkgs.lib.composeManyExtensions [
      nix-topology
      modifications
      stable-packages
    ];

    # from inputs
    nix-topology = inputs.nix-topology.overlays.default;

    # my overlays
    modifications = final: prev: {
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
  };
}
