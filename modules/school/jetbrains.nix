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
        ++ [ (buildIdeWithPlugins pkgs "idea" pluginList) ];

      xdg.configFile = {
        "ideavim/ideavimrc".text = ''
          source ${inputs.helix-vim}/src/helix.idea.vim
        '';
        "JetBrains/IntelliJIdea${pkgs.jetbrains.idea.version}/idea64.vmoptions".text =
          "-Dawt.toolkit.name=WLToolkit";
      };
    };
}
