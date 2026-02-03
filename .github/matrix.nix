let
  # we are in .github/matrix.nix, so we need to go up one level to find the flake
  flake = builtins.getFlake (toString ../.);
  pkgs = import flake.inputs.nixpkgs { system = "x86_64-linux"; };
  inherit (pkgs) lib;

  getSystem = config: config.config.nixpkgs.hostPlatform.system;

  nixosConfigs = flake.nixosConfigurations or { };
  darwinConfigs = flake.darwinConfigurations or { };

  getRunner =
    system:
    if system == "aarch64-linux" then
      "ubuntu-24.04-arm"
    else if system == "aarch64-darwin" then
      "macos-latest"
    else
      "ubuntu-latest";

  nixosList = lib.mapAttrsToList (name: config: {
    hostname = name;
    output = "nixosConfigurations";
    arch = getSystem config;
    runs-on = getRunner (getSystem config);
  }) nixosConfigs;

  darwinList = lib.mapAttrsToList (name: config: {
    hostname = name;
    output = "darwinConfigurations";
    arch = getSystem config;
    runs-on = getRunner (getSystem config);
  }) darwinConfigs;
in
{
  include = nixosList ++ darwinList;
}
