{
  programs.vesktop = {
    enable = true;
    settings = {
      discordBranch = "canary";
      minimizeToTray = false;
      arRPC = true;
      splashTheming = true;
      enableMenu = true;
    };
  };

  home.file.".config/wireplumber/main.lua.d/99-stop-vesktop-microphone-adjust.lua".text = ''
    table.insert(default_access.rules, {
        matches = {
            {
                { "application.process.binary", "=", "vesktop.bin" },
            },
        },
        default_permissions = "rx",
    })
  '';
}
