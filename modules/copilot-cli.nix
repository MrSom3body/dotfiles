{ inputs, ... }: {
  flake.modules.homeManager.copilot-cli = { pkgs, ... }: {
    home.packages = [ inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli ];
  };
}
