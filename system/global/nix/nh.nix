{
  self,
  inputs,
  pkgs,
  settings,
  isInstall,
  ...
}: {
  programs.nh = {
    enable = true;
    package = inputs.nh.packages.${pkgs.system}.default;
    clean = {
      enable = true;
      extraArgs = "--keep-since 1w --keep 3";
    };
    flake =
      if isInstall
      then settings.path
      else self.outPath;
  };
}
