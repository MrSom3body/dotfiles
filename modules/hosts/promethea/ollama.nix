{ config, ... }:
{
  flake.modules.nixos."hosts/promethea" = {
    specialisation.enable-ollama.configuration = {
      environment.etc."specialisation".text = "enable-ollama"; # for nh
      system.nixos.tags = [ "enable-ollama" ]; # to display it in the boot loader
      imports = [ config.flake.modules.nixos.ollama ];
    };

    services.ollama.acceleration = "cuda";
  };
}
