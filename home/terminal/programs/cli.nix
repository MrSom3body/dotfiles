{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs;
    [
      # nix
      comma

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
    ]
    ++ [
      inputs.gotcha.packages.${pkgs.system}.default
    ];
}
