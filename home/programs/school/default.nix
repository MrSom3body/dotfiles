{pkgs, ...}: {
  home.packages = with pkgs; [
    # IDEs
    (pkgs.jetbrains.plugins.addPlugins jetbrains.datagrip ["github-copilot-intellij" "ideavim"])
    (pkgs.jetbrains.plugins.addPlugins jetbrains.idea-ultimate ["github-copilot-intellij" "ideavim"])
    (pkgs.jetbrains.plugins.addPlugins jetbrains.phpstorm ["github-copilot-intellij" "ideavim"])

    # JDKs
    temurin-bin

    # Other thingies
    ciscoPacketTracer8
  ];
}
