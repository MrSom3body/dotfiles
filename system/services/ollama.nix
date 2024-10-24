{
  config,
  lib,
  ...
}: {
  services.ollama = {
    enable = true;
    loadModels = ["llama3.2:3b-instruct-q4_K_M" "llava"];
  };

  specialisation.ollamaGPU.configuration = {
    environment.etc."specialisation".text = "ollamaGPU";
    services.ollama.acceleration = "cuda";
    boot.kernelModules = lib.mkIf config.services.ollama.enable ["nvidia_uvm"];
  };
}
