{ inputs, ... }:
{
  flake.modules.homeManager.hermes-agent =
    { pkgs, ... }:
    {
      home.packages = [ inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.hermes-agent ];
    };
}
