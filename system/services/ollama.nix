{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    loadModels = ["llama3.2" "llama2-uncensored" "llava"];
  };
}
