{
  flake.modules = {
    nixos.nixos = {
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };

    homeManager.homeManager =
      { osConfig, ... }:
      {
        home = {
          username = "karun";
          homeDirectory = "/home/karun";
          inherit (osConfig.system) stateVersion;
        };

        programs.home-manager.enable = true;
      };
  };
}
