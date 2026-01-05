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

      # TODO remove when https://github.com/NixOS/nixpkgs/pull/477215 lands in unstable
      solaar = prev.solaar.overrideAttrs (_oldAttrs: rec {
        version = "1.1.18";
        src = final.fetchFromGitHub {
          owner = "pwr-Solaar";
          repo = "Solaar";
          tag = version;
          hash = "sha256-K1mh1FgdYe1yioczUoOb7rrI0laq+1B4TLlblerMyHE=";
        };

        preConfigure = ''
          substituteInPlace lib/solaar/listener.py \
            --replace-fail getfacl "${final.lib.getExe' final.acl "getfacl"}"
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
