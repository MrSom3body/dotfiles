{pkgs, ...}: {
  imports = [
    ./zathura.nix
  ];

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      # Documents
      libreoffice-fresh
      simple-scan
      # Notes & Tasks
      obsidian
      todoist-electron
      # Communication
      protonmail-desktop
      slack
      ;
  };
}
