{ inputs, ... }:
{
  flake.modules.homeManager.gemini-cli =
    { pkgs, ... }:
    {
      programs.gemini-cli = {
        enable = true;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gemini-cli;
        settings = {
          general = {
            previewFeatures = true;
            vimMode = true;
          };
          privacy.usageStatisticsEnabled = false;
          security = {
            disableYoloMode = true;
            auth.selectedType = "oauth-personal";
          };
        };
      };
    };
}
