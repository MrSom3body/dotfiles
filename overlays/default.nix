{inputs, ...}: {
  additions = final: _prev: import ../pkgs {inherit (final) pkgs;};

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
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
