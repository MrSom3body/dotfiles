{
  pkgs,
  pkgs-stable,
  ...
}: {
  home.packages =
    (with pkgs; [
      # Documents
      papers
      simple-scan

      # Notes & Tasks
      lunatask
      obsidian

      # Communication
      protonmail-desktop
      slack
    ])
    ++ (with pkgs-stable; [
      libreoffice-fresh
    ]);
}
