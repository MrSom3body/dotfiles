{ inputs, ... }:
{
  flake.modules.nixos.nixos = {
    imports = [ inputs.comin.nixosModules.comin ];
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/MrSom3body/dotfiles.git";
        }
      ];
    };
  };
}
