{
  flake.modules.nixos.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      virtualisation = {
        oci-containers.backend = "podman";
        podman = {
          # Create a `docker` alias for podman, to use it as a drop-in replacement
          dockerCompat = true;
          dockerSocket.enable = true;

          # Required for containers under podman-compose to be able to talk to each other.
          defaultNetwork.settings.dns_enabled = true;
        };
      };

      environment.systemPackages = lib.mkIf config.virtualisation.podman.enable (
        builtins.attrValues {
          inherit (pkgs)
            #docker-compose # start group of containers for dev
            dive # look into docker image layers
            podman-compose # start group of containers for dev
            podman-tui # status of containers in the terminal
            ;
        }
      );
    };
}
