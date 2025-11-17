{ inputs, ... }:
{
  flake.overlays = {
    modifications =
      final: prev:
      let
        gns3-version = "2.2.54";
      in
      {
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

        # TODO remove when https://nixpk.gs/pr-tracker.html?pr=462174 gets merged
        gns3-gui = prev.gns3-gui.overrideAttrs (_oldAttrs: {
          src = final.fetchFromGitHub {
            owner = "GNS3";
            repo = "gns3-gui";
            tag = "v${gns3-version}";
            hash = "sha256-rR7hrNX7BE86x51yaqvTKGfcc8ESnniFNOZ8Bu1Yzuc=";
          };
        });

        gns3-server = prev.gns3-server.overrideAttrs (_oldAttrs: {
          src = final.fetchFromGitHub {
            owner = "GNS3";
            repo = "gns3-server";
            tag = "v${gns3-version}";
            hash = "sha256-ih/9zIJtex9ikZ4oCuyYEjZ3U/BtxDojOz6FnJ0HOYU=";
          };
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
