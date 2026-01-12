{
  flake.modules = {
    nixos.desktop = {
      security.pam.services = {
        greetd.enableGnomeKeyring = true;
        greetd-password.enableGnomeKeyring = true;
        login.enableGnomeKeyring = true;
      };
    };

    homeManager.desktop =
      { pkgs, ... }:
      {
        home.packages = builtins.attrValues {
          inherit (pkgs)
            gcr
            seahorse
            ;
        };

        services.gnome-keyring = {
          enable = true;
          components = [
            "pkcs11"
            "secrets"
          ];
        };
      };
  };
}
