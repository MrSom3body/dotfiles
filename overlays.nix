{...}: {
  nixpkgs.overlays = [
    (
      final: prev: {
        linuxPackages_xanmod_latest = prev.linuxPackages_xanmod_latest.extend (
          _lpfinal: _lpprev: {
            vmware = prev.linuxPackages_xanmod_latest.vmware.overrideAttrs (_oldAttrs: {
              version = "workstation-17.5.2-k6.9+-unstable-2024-08-22";
              src = final.fetchFromGitHub {
                owner = "nan0desu";
                repo = "vmware-host-modules";
                rev = "b489870663afa6bb60277a42a6390c032c63d0fa";
                hash = "sha256-9t4a4rnaPA4p/SccmOwsL0GsH2gTWlvFkvkRoZX4DJE=";
              };
            });
          }
        );
      }
    )
  ];
}
