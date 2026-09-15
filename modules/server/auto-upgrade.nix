{ inputs, ... }: {
  flake.modules.nixos.server = {
    imports = [ inputs.comin.nixosModules.comin ];
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          branches.main.operation = "boot";
          url = "https://github.com/MrSom3body/dotfiles.git";
        }
      ];
    };
  };
}
