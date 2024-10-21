{
  lib,
  dotfiles,
  ...
}: {
  services.ollama = {
    enable = lib.mkIf ((builtins.length dotfiles.ollamaModels) == 1) true;
    acceleration = "cuda";
    loadModels = dotfiles.ollamaModels;
  };
}
