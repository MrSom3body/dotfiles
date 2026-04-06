{
  flake.modules.nixos.ollama = {
    services.ollama = {
      enable = true;
      syncModels = true;
    };
  };
}
