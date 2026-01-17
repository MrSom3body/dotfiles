{
  self,
  lib,
  inputs,
  ...
}:
{
  flake.modules.nixos.nixos =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.git ];

      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 3d --keep 3";
        };
        flake = "/home/karun/dotfiles";
      };

      nix =
        let
          flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
        in
        {
          # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
          registry = lib.mapAttrs (_: v: { flake = v; }) flakeInputs;
          nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
          channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.

          settings = {
            accept-flake-config = lib.mkForce false;
            log-lines = lib.mkDefault 25; # more log lines

            builders-use-substitutes = true;
            experimental-features = [
              "nix-command"
              "flakes"
            ];

            keep-derivations = true;
            keep-outputs = true;

            trusted-users = [
              "root"
              "@wheel"
            ];
          };

          optimise.automatic = !config.boot.isContainer;
        };

      nixpkgs = {
        config.allowUnfree = true;
        overlays = builtins.attrValues self.overlays;
      };
    };
}
