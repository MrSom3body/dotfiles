{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    loadModels = ["llama3.2"];
  };
}
