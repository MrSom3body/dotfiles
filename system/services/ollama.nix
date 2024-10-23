{
  config,
  lib,
  ...
}: {
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    loadModels = ["llama3.2" "llama2-uncensored" "llava"];
  };

  boot.kernelModules = lib.mkIf config.services.ollama.enable ["nvidia_uvm"];
}
