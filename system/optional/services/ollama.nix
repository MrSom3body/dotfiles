{
  specialisation.enableOllama.configuration = {
    environment.etc."specialisation".text = "enableOllama";
    services.ollama = {
      enable = true;
      loadModels = [
        "deepseek-r1:14b"
        "llama3.2:3b-instruct-q8_0"
      ];
    };
  };
}
