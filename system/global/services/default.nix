{isInstall, ...}: {
  imports =
    [
      ./dbus.nix
    ]
    ++ (
      if isInstall
      then [./tailscale.nix]
      else []
    );
}
