{ inputs, ... }:
{
  flake.overlays = {
    modifications = final: prev: {
      obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          wrapProgram $out/bin/obsidian \
            --prefix PATH : ${final.lib.makeBinPath [ final.pandoc ]}
        '';
      });

      # TODO remove when https://github.com/nixos/nixpkgs/pull/476229 lands in unstable
      readline70 = prev.readline70.overrideAttrs (_oldAttrs: {
        env.NIX_CFLAGS_COMPILE = final.lib.optionalString final.stdenv.cc.isGNU "-std=gnu17";
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
