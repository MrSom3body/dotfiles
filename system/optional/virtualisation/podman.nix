{pkgs, ...}: {
  # Enable common container config files in /etc/containers
  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      dockerSocket.enable = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    #docker-compose # start group of containers for dev
    distrobox
    dive # look into docker image layers
    podman-compose # start group of containers for dev
    podman-tui # status of containers in the terminal
  ];
}
