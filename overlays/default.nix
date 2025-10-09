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
    };

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final) system;
        config.allowUnfree = true;
      };
    };
  };
}
