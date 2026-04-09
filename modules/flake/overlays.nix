{ inputs, ... }:
{
  flake.overlays = {
    # from inputs
    hyprnix = inputs.hyprnix.overlays.default;
    nix-topology = inputs.nix-topology.overlays.default;

    # my overlays
    modifications = final: prev: {
      obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          wrapProgram $out/bin/obsidian \
            --prefix PATH : ${final.lib.makeBinPath [ final.pandoc ]}
        '';
      });

      # TODO remove when https://github.com/NixOS/nixpkgs/pull/506893 lands in unstable
      deno = prev.deno.overrideAttrs (oldAttrs: {
        patches =
          (oldAttrs.patches or [ ])
          ++ final.lib.optionals (final.stdenv.hostPlatform.isAarch64 && final.stdenv.hostPlatform.isLinux) [
            (final.fetchpatch {
              url = "https://github.com/denoland/deno/commit/fd331552de39501d47c43dc4b0c637b969402ab1.patch";
              hash = "sha256-AIqLbTnBO2VUFiTumEZFORqSyfzB6chdvJQq8HeAM30=";
            })
          ];
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
