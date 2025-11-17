{ inputs, ... }:
{
  flake.modules.homeManager.school =
    { pkgs, ... }:
    {
      home.packages =
        let
          plugins = [
            "github-copilot--your-ai-pair-programmer"
            "ideavim"
            "mermaid"
          ];
        in
        builtins.attrValues {
          inherit (pkgs)
            # IDEs
            jetbrains-toolbox
            # JDKs
            temurin-bin
            # Other thingies
            anki-bin
            openfortivpn
            vpnc
            ;
        }
        ++ [
          (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.datagrip plugins)
          (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate plugins)
          # (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.phpstorm plugins)
          # (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.pycharm-professional plugins)
        ];

      xdg.configFile."ideavim/ideavimrc".text = ''
        source ${inputs.helix-vim}/src/helix.idea.vim
      '';
    };
}
