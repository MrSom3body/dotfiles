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
      speedtest-cli
      wget

      # net
      dig
      inetutils
    ]
    ++ [
      inputs.gotcha.packages.${pkgs.system}.default
    ];
}
