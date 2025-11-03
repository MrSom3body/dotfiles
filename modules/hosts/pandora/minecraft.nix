{ config, ... }:
{
  flake.modules.nixos."hosts/pandora" =
    { pkgs, ... }:
    {
      imports = [ config.flake.modules.nixos.minecraft-server ];

      services.minecraft-servers.servers = {
        kn-server = {
          enable = true;
          enableReload = true;
          openFirewall = true;
          package = pkgs.vanillaServers.vanilla-1_21_10;
          jvmOpts = "-Xms1G -Xmx4G";
          serverProperties = {
            difficulty = "normal";
            enforce-secure-profile = false;
            motd = "The KN Server";
            online-mode = true;
            server-port = 25565;
          };
          operators = {
            MrSom3body_ = "baef9d99-3ea2-4e70-93f6-cf763e33f113";
          };
        };
      };
    };
}
