{
  self,
  lib,
  inputs,
  ...
}:
{
  flake.modules =
    let
      sharedNixpkgs = {
        config.allowUnfree = true;
        overlays = [ self.overlays.default ];
      };
    in
    {
      nixos.nixos = { config, pkgs, ... }: {
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

              min-free = 128000000;
              max-free = 1000000000;
              auto-optimise-store = true;

              connect-timeout = 0;
              fallback = true;

              warn-dirty = false;

              cores = 0;
              max-jobs = "auto";

              builders-use-substitutes = true;
              experimental-features = [
                "nix-command"
                "flakes"
                "auto-allocate-uids"
                "configurable-impure-env"
                "pipe-operators"
              ];
              impure-env = [ "NIXPKGS_ALLOW_UNFREE" ];

              keep-derivations = true;
              keep-outputs = true;

              trusted-users = [ "@wheel" ];

              use-xdg-base-directories = true; # Why wouldn't this be the default?
            };
          };

        nixpkgs = sharedNixpkgs;
      };

      homeManager.homeManager =
        {
          osConfig ? null,
          ...
        }:
        {
          nixpkgs = lib.mkIf (osConfig == null || !osConfig.home-manager.useGlobalPkgs) sharedNixpkgs;
          home.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
        };
    };
}
