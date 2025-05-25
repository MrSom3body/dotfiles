{isInstall, ...}: {
  imports =
    [
      ./command-not-found.nix
      ./fish.nix
      ./helix.nix
    ]
    ++ (
      if isInstall
      then [./home-manager.nix]
      else []
    );
}
