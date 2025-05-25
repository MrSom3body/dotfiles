{isInstall, ...}: {
  imports =
    [
      ./command-not-found.nix
      ./fish.nix
    ]
    ++ (
      if isInstall
      then [./home-manager.nix]
      else []
    );
}
