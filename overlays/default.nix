{
  inputs,
  outputs,
  ...
}: {
  additions = final: _prev:
    import ../pkgs {
      inherit outputs;
      inherit (final) pkgs;
    };

  modifications = final: prev: let
    nixpkgs-jetbrains =
      import (builtins.fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/42a1c966be226125b48c384171c44c651c236c22.tar.gz";
        sha256 = "sha256:082dpl311xlspwm5l3h2hf10ww6l59m7k2g2hdrqs4kwwsj9x6mf";
      }) {
        inherit (final.pkgs) system;
        config.allowUnfree = true;
      };
  in {
    bemoji = prev.bemoji.overrideAttrs (_oldAttrs: {
      version = "unstable-2025-03-17";
      src = final.fetchFromGitHub {
        owner = "marty-oehme";
        repo = "bemoji";
        rev = "1b5e9c1284ede59d771bfd43780cc8f6f7446f38";
        hash = "sha256-WD4oFq0NRZ0Dt/YamutM7iWz3fMRxCqwgRn/rcUsTIw=";
      };
    });

    obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
      postInstall =
        (oldAttrs.postInstall or "")
        + ''
          wrapProgram $out/bin/obsidian \
            --prefix PATH : ${final.lib.makeBinPath [final.pandoc]}
        '';
    });

    vesktop = prev.vesktop.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches ++ [./vesktop-disable-auto-gain.patch];
    });

    vpnc = prev.vpnc.overrideAttrs (_oldAttrs: {
      version = "unstable-2024-12-20";
      src = final.fetchFromGitHub {
        owner = "streambinder";
        repo = "vpnc";
        rev = "d58afaaafb6a43cb21bb08282b54480d7b2cc6ab";
        hash = "sha256-79DaK1s+YmROKbcWIXte+GZh0qq9LAQlSmczooR86H8=";
      };
    });

    send = (prev.send.overrideAttrs
      (_oldAttrs: rec {
        pname = "send";
        version = "3.4.25";
        src = final.fetchFromGitHub {
          owner = "timvisee";
          repo = "send";
          tag = "v${version}";
          hash = "sha256-2XeChKJi57auIf9aSe2JlP55tiE8dmrCBtUfCkziYi8=";
        };
        npmDepsHash = "sha256-DY+4qOzoURx8xmemhutxcNxg0Tv2u6tyJHK5RhBjo8w=";
        npmDeps = final.fetchNpmDeps {
          inherit src;
          name = "${pname}-${version}-npm-deps";
          hash = npmDepsHash;
        };
      })).override {
      nodejs = final.nodejs_20;
    };

    # TODO delete when https://github.com/NixOS/nixpkgs/issues/400317 gets resolved
    inherit (nixpkgs-jetbrains) jetbrains;
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
