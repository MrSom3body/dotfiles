{
  flake.modules.nixos."hosts/promethea" = {
    nixpkgs.config.permittedInsecurePackages = [ "qtwebengine-5.15.19" ]; # TODO remove https://github.com/NixOS/nixpkgs/issues/437865
  };
}
