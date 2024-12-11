{pkgs, ...}: {
  services.printing = {
    enable = true;
    browsed.enable = true;
    drivers = with pkgs; [
      gutenprint
    ];
  };
}
