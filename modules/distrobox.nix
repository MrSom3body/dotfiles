{
  flake.modules.homeManager.distrobox = {
    programs = {
      distrobox = {
        enable = true;
        settings = {
          container_additional_volumes = "/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro";
        };
        containers = {
          work = {
            entry = true;
            image = "ubuntu:latest";
          };
        };
      };

      fish.interactiveShellInit = ''
        if set -q CONTAINER_ID
          fish_add_path --prepend /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
        end
      '';
    };
  };
}
