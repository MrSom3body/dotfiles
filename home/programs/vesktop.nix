{pkgs, ...}: {
  home.packages = with pkgs; [
    vesktop
  ];

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
