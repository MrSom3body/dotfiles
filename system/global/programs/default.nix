{isInstall, ...}: {
  imports =
    [
      ./command-not-found.nix
      ./fish.nix
      ./helix.nix
      ./starship.nix
    ]
    ++ (
      if isInstall
      then [./home-manager.nix]
      else []
    );
}
