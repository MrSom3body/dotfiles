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

    # TODO delete when https://github.com/NixOS/nixpkgs/pull/411885 gets merged
    linuxPackages_latest = prev.linuxPackages_latest.extend (_lpfinal: _lpprev: {
      vmware = prev.linuxPackages_latest.vmware.overrideAttrs (oldAttrs: {
        src = final.fetchFromGitHub {
          owner = "philipl";
          repo = "vmware-host-modules";
          rev = "93d8bf38d7e705a862dcbfa721884638a817d476";
          hash = "sha256-i2E3QAy5P3U+EqSaFaCQGuiU4vt/yYKv3oJBP1qK9Og=";
        };

        patches =
          oldAttrs.patches or []
          ++ [
            (final.fetchpatch {
              # https://github.com/philipl/vmware-host-modules/pull/1
              url = "https://github.com/amadejkastelic/vmware-host-modules/commit/926cfc50c017a099c796662c8e2820d12f94d0bb.patch";
              hash = "sha256-9XLhypr77Qy9Ty54Pm48DYYh3HT1WAmiwGOmBk3AfyI=";
            })
          ];
      });
    });

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
