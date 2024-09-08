{pkgs, ...}: {
  services.fprintd = {
    enable = true;
    tod = {
      enable = false;
      driver = pkgs.libfprint-2-tod1-elan;
    };
  };

  security.pam.services = {
    hyprlock = {
      text = ''
        auth sufficient pam_unix.so try_first_pass likeauth nullok
        auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
        auth include login
      '';
    };
  };
}
