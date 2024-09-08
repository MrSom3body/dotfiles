{pkgs, ...}: {
  # environment.sessionVariables = {
  #   FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts";
  #   FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
  # };

  fonts.packages = with pkgs; [
    (nerdfonts.override
      {
        fonts = [
          "Ubuntu"
          "FiraCode"
        ];
      })
  ];
}
