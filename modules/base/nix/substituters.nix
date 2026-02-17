{
  flake.modules.nixos.nixos = {
    nix.settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://som3cache.cachix.org"
        "https://cache.garnix.io"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "som3cache.cachix.org-1:Ssytf0zRSaOXkXqTof3B7m+QipSjdUfEwhJuvcpTZOY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
