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

    yaziPlugins = prev.yaziPlugins // {
      git =
        if prev.yaziPlugins.git.version == "0-unstable-2026-08-12" then
          throw "yaziPlugins.git updated to 0-unstable-2026-08-12, check if overlay still needed"
        else
          prev.yaziPlugins.git.overrideAttrs (_oldAttrs: {
            version = "0-unstable-2026-08-12";
            src = prev.fetchFromGitHub {
              owner = "yazi-rs";
              repo = "plugins";
              rev = "3f2b8822aa77f8699d70803ef1407ef7a2a77b0d";
              hash = "sha256-ixdQLt8DJZRqoK4GqwaytxSrLGc+B5L+ILBs7eG6kLY=";
            };
          });
    };
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
