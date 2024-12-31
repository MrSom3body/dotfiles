{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs;
    [
      # archives
      zip
      unzip
      unrar

      # misc
      libnotify

      # utils
      devenv
      glow
      speedtest-cli
      wget
    ]
    ++ [
      (inputs.gotcha.packages.${pkgs.system}.default.override {
        ifaceName = "wlp2s0";
      })
    ];
}
