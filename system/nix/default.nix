{pkgs, ...}: {
  imports = [
    ./substituters.nix

    ./nh.nix
  ];

  environment.systemPackages = [pkgs.git];

  nix = {
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}