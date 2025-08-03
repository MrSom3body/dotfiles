{ inputs, ... }:
{
  modifications =
    final: prev:
    let
      nixpkgs-jetbrains =
        import
          (builtins.fetchTarball {
            url = "https://github.com/nixos/nixpkgs/archive/42a1c966be226125b48c384171c44c651c236c22.tar.gz";
            sha256 = "sha256:082dpl311xlspwm5l3h2hf10ww6l59m7k2g2hdrqs4kwwsj9x6mf";
          })
          {
            inherit (final.pkgs) system;
            config.allowUnfree = true;
          };
    in
    {
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
