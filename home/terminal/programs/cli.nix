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
    ]
    ++ [
      inputs.gotcha.packages.${pkgs.system}.default
    ];
}
