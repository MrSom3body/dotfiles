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

      solaar = prev.solaar.overrideAttrs (
        _oldAttrs:
        let
          version = "1.1.16";
        in
        {
          inherit version;
          src = final.fetchFromGitHub {
            owner = "pwr-Solaar";
            repo = "Solaar";
            tag = version;
            hash = "sha256-PhZoDRsckJXk2t2qR8O3ZGGeMUhmliqSpibfQDO7BeA=";
          };
        }
      );
    };

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final) system;
        config.allowUnfree = true;
      };
    };
  };
}
