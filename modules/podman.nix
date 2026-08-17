{
  flake.modules.nixos.podman = {
    virtualisation = {
      # Enable common container config files in /etc/containers
      containers.enable = true;

      podman.enable = true;
    };

    systemd.timers.podman-auto-update.wantedBy = [ "multi-user.target" ];
  };
}
