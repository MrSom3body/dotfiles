{
  flake.modules.nixos.ollama = {
    services.ollama = {
      enable = true;
      loadModels = [
        "deepseek-r1:14b"
        "llama3.2:3b-instruct-q8_0"
      ];
    };
  };
}
