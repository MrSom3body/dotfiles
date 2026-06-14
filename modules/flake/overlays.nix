{ inputs, ... }: {
  flake.overlays = rec {
    default = inputs.nixpkgs.lib.composeManyExtensions [
      lixify
      nix-topology
      modifications
      stable-packages
    ];

    # from inputs
    nix-topology = inputs.nix-topology.overlays.default;

    # my overlays
    lixify = final: prev: {
      inherit (prev.lixPackageSets.latest)
        lix # so that I can set the lix version in one place
        colmena
        nix-eval-jobs
        nix-fast-build
        nixpkgs-review
        ;
      nix-direnv = prev.nix-direnv.override { nix = final.lix; };
    };

    modifications = final: prev: {
      # TODO remove when https://github.com/NixOS/nixpkgs/pull/530302 lands in unstable
      regreet = prev.regreet.overrideAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
          final.gst_all_1.gstreamer
          final.gst_all_1.gst-plugins-good
          final.gst_all_1.gst-plugins-base
        ];
      });

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
