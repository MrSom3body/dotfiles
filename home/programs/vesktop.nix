{pkgs, ...}: {
  home.packages = with pkgs; [
    # TODO revert electron version when streaming works again
    (vesktop.override {
      electron = pkgs.electron_33;
    })
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
