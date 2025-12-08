{
  flake.modules.homeManager.office =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Documents
        libreoffice-fresh
        simple-scan
        xournalpp
        # Notes & Tasks
        obsidian
        # Communication
        protonmail-desktop
      ];
    };
}
