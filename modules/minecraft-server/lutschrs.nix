{ config, ... }: {
  flake.modules.nixos."minecraft-server/lutschrs" = { pkgs, ... }: {
    imports = [ config.flake.modules.nixos.minecraft-server ];

    services.minecraft-servers.servers.lutschrs =
      let
        # TODO https://github.com/StormDragon-64/Create-Plus/issues/90
        modpack = pkgs.fetchModrinthModpack {
          url = "https://cdn.modrinth.com/data/t1tOiUHZ/versions/3XKDXorU/Create%2B-6.0.0%20Alpha%20E.mrpack?mr_download_reason=standalone";
          packHash = "sha256-mebbeDTuphgm37ofni54W1e/mN40hwvnOEH9okcH2yY=";
          side = "server";
        };
      in
      {
        enable = true;
        openFirewall = true;
        package = pkgs.minecraftServers.neoforge-1_21_1;
        jvmOpts = "-Xms1G -Xmx7G";
        serverProperties = {
          difficulty = "normal";
          enforce-secure-profile = false;
          motd = "The Lutschrs Server";
          online-mode = true;
          server-port = 25565;
        };
        symlinks = {
          "mods" = "${modpack}/mods";
        };
        files = {
          "config" = "${modpack}/config";
          "configureddefaults" = "${modpack}/configureddefaults";
        };
        operators = {
          MrSom3body_ = "baef9d99-3ea2-4e70-93f6-cf763e33f113";
        };
      };

    systemd.services."minecraft-server-lutschrs".path = [ pkgs.ncurses ];
  };
}
