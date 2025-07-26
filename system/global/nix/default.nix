{
  config,
  outputs,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./nh.nix
    ./substituters.nix
  ];

  environment.systemPackages = [ pkgs.git ];

  nix = {
    package = pkgs.lix;

    settings = {
      accept-flake-config = false;
      auto-optimise-store = !config.boot.isContainer;
      builders-use-substitutes = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
      ];

      keep-derivations = true;
      keep-outputs = true;

      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    registry.nixpkgs.flake = inputs.nixpkgs;
    channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = builtins.attrValues outputs.overlays;
  };
}
