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

      # utils
      devenv
      glow
      ripdrag
      speedtest-cli
      wget

      # net
      dig
    ]
    ++ [
      inputs.gotcha.packages.${pkgs.system}.default
    ];
}
