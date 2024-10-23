{
  config,
  lib,
  ...
}: {
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    loadModels = ["llama3.2:3b-instruct-q4_K_M" "llava"];
  };

  boot.kernelModules = lib.mkIf config.services.ollama.enable ["nvidia_uvm"];
}
