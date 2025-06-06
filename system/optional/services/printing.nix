{pkgs, ...}: {
  services.printing = {
    enable = true;
    browsed.enable = true;
    drivers = builtins.attrValues {
      inherit
        (pkgs)
        gutenprint
        hplip
        ;
    };
  };
}
