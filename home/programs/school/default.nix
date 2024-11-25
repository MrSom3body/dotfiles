{pkgs, ...}: {
  home.packages = with pkgs; let
    plugins = ["github-copilot" "ideavim" "mermaid"];
  in [
    # IDEs
    (pkgs.jetbrains.plugins.addPlugins jetbrains.datagrip plugins)
    (pkgs.jetbrains.plugins.addPlugins jetbrains.idea-ultimate plugins)
    (pkgs.jetbrains.plugins.addPlugins jetbrains.phpstorm plugins)

    # JDKs
    temurin-bin

    # Other thingies
    ciscoPacketTracer8
  ];
}
