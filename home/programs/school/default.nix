{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; let
    plugins = ["github-copilot" "ideavim" "mermaid"];
  in [
    # IDEs
    (pkgs.jetbrains.plugins.addPlugins jetbrains.datagrip plugins)
    (pkgs.jetbrains.plugins.addPlugins jetbrains.idea-ultimate plugins)
    (pkgs.jetbrains.plugins.addPlugins jetbrains.phpstorm plugins)
    pkgs.jetbrains-toolbox

    # JDKs
    temurin-bin

    # Other thingies
    anki-bin
    ciscoPacketTracer8
    openfortivpn
    vpnc
  ];

  home.file.".ideavimrc".text = ''
    source ${inputs.helix-vim}/src/helix.idea.vim
  '';
}
