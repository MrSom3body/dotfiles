{
  flake.modules.homeManager.office = { pkgs, ... }: {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        # Documents
        libreoffice
        simple-scan
        xournalpp
        # Communication
        protonmail-desktop
        ;
    };
  };
}
