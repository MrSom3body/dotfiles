{
  flake.modules.homeManager.office =
    { pkgs, ... }:
    {
      home.packages = builtins.attrValues {
        inherit (pkgs)
          # Documents
          libreoffice-fresh
          simple-scan
          xournalpp
          # Notes & Tasks
          obsidian
          # Communication
          protonmail-desktop
          ;
      };
    };
}
