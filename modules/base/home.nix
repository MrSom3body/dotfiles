{
  flake.modules = {
    nixos.base = {
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };

    homeManager.base = {
      home = {
        username = "karun";
        homeDirectory = "/home/karun";
      };

      programs.home-manager.enable = true;
    };
  };
}
