{
  inputs,
  pkgs,
  ...
}: {
  home.packages = let
    plugins = ["github-copilot" "ideavim" "mermaid"];
  in
    builtins.attrValues {
      inherit
        (pkgs)
        # IDEs
        jetbrains-toolbox
        # JDKs
        temurin-bin
        # Other thingies
        anki-bin
        ciscoPacketTracer8
        openfortivpn
        vpnc
        ;
    }
    ++ [
      (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.datagrip plugins)
      (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate plugins)
      (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.phpstorm plugins)
    ];

  home.file.".ideavimrc".text = ''
    source ${inputs.helix-vim}/src/helix.idea.vim
  '';
}
