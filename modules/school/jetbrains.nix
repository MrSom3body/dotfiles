{ inputs, ... }:
{
  flake.modules.homeManager.school =
    { pkgs, ... }:
    let
      inherit (inputs.nix-jetbrains-plugins.lib."${pkgs.stdenv.hostPlatform.system}") buildIdeWithPlugins;
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
          (buildIdeWithPlugins pkgs.jetbrains "datagrip" pluginList)
          (buildIdeWithPlugins pkgs.jetbrains "idea" pluginList)
          # (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.phpstorm plugins)
          # (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.pycharm-professional plugins)
        ];

      xdg.configFile."ideavim/ideavimrc".text = ''
        source ${inputs.helix-vim}/src/helix.idea.vim
      '';
    };
}
