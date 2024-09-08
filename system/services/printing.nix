{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      hplip
      splix
    ];
  };
}
