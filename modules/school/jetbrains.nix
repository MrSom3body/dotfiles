{ inputs, ... }:
{
  flake.modules.homeManager.school =
    { pkgs, ... }:
    let
      inherit (inputs.nix-jetbrains-plugins.lib) buildIdeWithPlugins;
      pluginList = [
        "IdeaVIM"
        "com.almightyalpaca.intellij.plugins.discord"
        "com.github.copilot"
        "com.github.lonre.gruvbox-intellij-theme"
        # "com.intellij.mermaid"
      ];
    in
    {
      home.packages =
        builtins.attrValues {
          inherit (pkgs)
            jetbrains-toolbox
            # JDKs
            temurin-bin
            ;
        }
        ++ [
          (buildIdeWithPlugins pkgs "datagrip" pluginList)
          (buildIdeWithPlugins pkgs "idea" pluginList)
          # (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.phpstorm plugins)
          # (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.pycharm-professional plugins)
        ];

      xdg.configFile."ideavim/ideavimrc".text = ''
        source ${inputs.helix-vim}/src/helix.idea.vim
      '';
    };
}
