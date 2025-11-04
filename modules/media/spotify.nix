{ inputs, ... }:
{
  flake.modules = {
    nixos.media = {
      networking.firewall.allowedTCPPorts = [
        4070
        57621
      ];
    };

    homeManager.media =
      { pkgs, ... }:
      {
        imports = [ inputs.spicetify-nix.homeManagerModules.default ];

        programs.spicetify =
          let
            spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
          in
          {
            enable = true;
            enabledExtensions = builtins.attrValues {
              inherit (spicePkgs.extensions)
                adblock
                betterGenres
                # keyboardShortcuts
                volumePercentage
                ;
            };
            enabledCustomApps = builtins.attrValues {
              inherit (spicePkgs.apps)
                lyricsPlus
                ncsVisualizer
                ;
            };
          };
      };
  };

}
