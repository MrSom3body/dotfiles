{ inputs, ... }:
{
  flake.modules.nixos.minecraft-server = {
    imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.minecraft-servers = {
      enable = true;
      dataDir = "/var/lib/minecraft";
      eula = true;
    };
  };
}
