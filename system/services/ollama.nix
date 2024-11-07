{
  config,
  lib,
  ...
}: {
  services.ollama = {
    enable = true;
    loadModels = ["llama3.2:3b-instruct-q4_K_M" "codellama:7b-code-q8_0" "llava"];
    acceleration = "cuda";
  };

  boot.kernelModules = lib.mkIf config.services.ollama.enable ["nvidia_uvm"];

  specialisation.ollamaNoGPU.configuration = {
    environment.etc."specialisation".text = "ollamaNoGPU";
    services.ollama.acceleration = lib.mkForce false;
  };
}
