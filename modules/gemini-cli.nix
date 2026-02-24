{ config, inputs, ... }:
let
  inherit (config.flake.meta) programs;
in
{
  flake.modules.homeManager.gemini-cli =
    { pkgs, ... }:
    {
      programs.gemini-cli = {
        enable = true;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gemini-cli;
        settings = {
          ui = {
            hidebanner = true;
            footer.hideContextPercentage = false;
            inlineThinkingMode = "full";
            showCitations = true;
            showModelInfoInChat = true;
            showStatusInTitle = true;
          };

          general = {
            preferredEditor = programs.editor;
            previewFeatures = true;
            vimMode = true;
            checkpointing.enabled = true;
          };
          context.discoveryMaxDirs = 1000;
          tools.shell.showColor = true;
          security = {
            disableYoloMode = true;
            auth.selectedType = "oauth-personal";
          };
          experimental.plan = true;

          privacy.usageStatisticsEnabled = false;
        };
      };
    };
}
