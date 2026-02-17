{
  flake.modules.nixos.nixos = {
    nix.settings = {
      substituters = [
        "https://som3cache.cachix.org"
        "https://cache.garnix.io"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "som3cache.cachix.org-1:Ssytf0zRSaOXkXqTof3B7m+QipSjdUfEwhJuvcpTZOY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
