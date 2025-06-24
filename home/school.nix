{
  inputs,
  pkgs,
  preFetch,
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
        openfortivpn
        vpnc
        ;
    }
    ++ [
      (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.datagrip plugins)
      (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate plugins)
      (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.phpstorm plugins)
    ]
    ++ (
      if preFetch
      # TODO switch back to unstable after https://github.com/NixOS/nixpkgs/pull/418679 gets merged
      then [pkgs.stable.ciscoPacketTracer8]
      else []
    );

  home.file.".ideavimrc".text = ''
    source ${inputs.helix-vim}/src/helix.idea.vim
  '';
}
