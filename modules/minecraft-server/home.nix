{ config, ... }:
let
  flakeModules = config.flake.modules;
in
{
  flake.modules.nixos."minecraft-server/home-server" = { pkgs, config, ... }: {
    imports = [ flakeModules.nixos.minecraft-server ];

    services =
      let
        port = 25565;
      in
      {
        caddy.virtualHosts."home.mc.${config.networking.domain}" = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString port}
          '';
        };

        minecraft-servers.servers.home-server = {
          enable = true;
          package = pkgs.minecraftServers.vanilla-26_2;
          jvmOpts = "-Xms1G -Xmx4G";
          serverProperties = {
            difficulty = "normal";
            enforce-secure-profile = false;
            motd = "The Home Server";
            online-mode = true;
            server-port = port;
          };
          operators = {
            MrSom3body_ = "baef9d99-3ea2-4e70-93f6-cf763e33f113";
          };
          whitelist = {
            MrSom3body_ = "baef9d99-3ea2-4e70-93f6-cf763e33f113";
            parteek_fr = "caf97fd6-6a67-4808-97ae-d365a1e4803a";
          };
        };
      };
  };
}
