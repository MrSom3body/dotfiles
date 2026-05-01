{ inputs, ... }:
{
  flake.overlays = {
    # from inputs
    hyprnix = inputs.hyprnix.overlays.default;
    nix-topology = inputs.nix-topology.overlays.default;

    # my overlays
    modifications = final: prev: {
      # TODO remove when https://github.com/NixOS/nixpkgs/pull/513877 lands in nixos-unstable
      davfs2 = prev.davfs2.overrideAttrs (_oldAttrs: {
        version = "1.7.3";
        src = prev.fetchurl {
          url = "mirror://savannah/davfs2/davfs2-1.7.3.tar.gz";
          hash = "sha256-pTaBYetQVWUdfl6BgMFgbaleeMlBtruKkobfeSPPy6k=";
        };
        nativeBuildInputs = [ prev.autoreconfHook269 ];
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
