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

      # misc
      libnotify

      # files
      ripdrag
      ripdrag

      # utils
      devenv
      glow
      speedtest-cli
      wget
    ]
    ++ [
      inputs.gotcha.packages.${pkgs.system}.default
    ];
}
