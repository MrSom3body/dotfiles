{ inputs, ... }:
{
  modifications = final: prev: {
    obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/obsidian \
          --prefix PATH : ${final.lib.makeBinPath [ final.pandoc ]}
      '';
    });

    # TODO delete when https://github.com/NixOS/nixpkgs/issues/430396 gets resolved
    linuxPackages_latest = prev.linuxPackages_latest.extend (
      _lpfinal: _lpprev: {
        vmware = prev.linuxPackages_latest.vmware.overrideAttrs (_oldAttrs: {
          version = "workstation-17.5.2-k6.9+-unstable-2024-08-22";
          src = final.fetchFromGitHub {
            owner = "philipl";
            repo = "vmware-host-modules";
            rev = "6797e552638a28d1fa1e9ebd7ab5d3c628671ba0";
            hash = "sha256-KCLxAF6UtNIdKcDoANviln2RJuz1Ld8jq5QFW9ONghs=";
          };
        });
      }
    );
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
