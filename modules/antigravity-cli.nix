{ inputs, ... }:
# let
#   inherit (config.flake.meta) programs;
# in
{
  flake.modules.homeManager.antigravity-cli = { pkgs, ... }: {
    home.packages = [ inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli ];
    programs.antigravity-cli = {
      enable = true;
      package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli;
      settings = {
        altScreenMode = "default";
        artifactReviewPolicy = "asks-for-review";
        colorScheme = "terminal";
        toolPermission = "proceed-in-sandbox";
        showTips = true;
        showFeedbackSurvey = false;
        enableTelemetry = false;
        trustedWorkspaces = [ "/home/karun/dotfiles" ];
      };
    };
    # programs.gemini-cli = {
    #   enable = true;
    #   package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gemini-cli;
    #   settings = {
    #     ui = {
    #       hideBanner = true;
    #       footer.hideContextPercentage = false;
    #       inlineThinkingMode = "full";
    #       showCitations = true;
    #       showModelInfoInChat = true;
    #       showStatusInTitle = true;
    #       useAlternateBuffer = true;
    #     };

    #     general = {
    #       preferredEditor = programs.editor;
    #       previewFeatures = true;
    #       sessionRetention = {
    #         enabled = true;
    #         maxAge = "30d";
    #         maxCount = 100;
    #       };
    #       vimMode = true;
    #       checkpointing.enabled = true;
    #     };
    #     ide.enabled = true;
    #     context = {
    #       fileName = [
    #         "AGENTS.md"
    #         "GEMINI.md"
    #       ];
    #       discoveryMaxDirs = 1000;
    #     };
    #     tools.shell.showColor = true;
    #     security = {
    #       disableYoloMode = true;
    #       auth.selectedType = "oauth-personal";
    #     };
    #     experimental = {
    #       enableAgents = true;
    #       plan = true;
    #     };

    #     privacy.usageStatisticsEnabled = false;
    #   };
    # };
  };
}
