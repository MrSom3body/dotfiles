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

  modifications = final: prev: {
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

    send =
      (prev.send.overrideAttrs (_oldAttrs: {
        version = "unstable-2025-03-16";
        src = final.fetchFromGitHub {
          owner = "timvisee";
          repo = "send";
          rev = "5124572dba7cac073d85f3e277d647aa3433ea38";
          hash = "sha256-31GWRufIvs51beLK2q7qo7WVmZ35DdCAe1fVfUV9YiI=";
        };
      }))
      .override {
        nodejs = final.nodejs_18;
      };
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
