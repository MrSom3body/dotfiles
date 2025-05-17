{pkgs, ...}: {
  import = [
    ../../../system/optional/services/minecraft.nix
  ];

  services.minecraft-servers.servers = {
    test = {
      enable = true;
      enableReload = true;
      openFirewall = true;
      package = pkgs.vanillaServers.vanilla-1_21_1;
      serverProperties = {
        difficulty = "normal";
        enforce-secure-profile = false;
        motd = "Server managed my pandora";
        online-mode = false;
        server-port = 25565;
      };
      jvmOpts = "-Xms1G -Xmx4G";
    };
  };
}
