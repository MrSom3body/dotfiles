{
  specialisation.enableOllama.configuration = {
    environment.etc."specialisation".text = "enableOllama";
    services.ollama = {
      enable = true;
      loadModels = ["llama3.2:3b-instruct-q4_K_M" "codellama:7b-code-q8_0" "llava"];
      acceleration = "cuda";
    };

    boot.kernelModules = ["nvidia_uvm"];
  };
}
