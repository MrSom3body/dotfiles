{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.quickshell.packages.${pkgs.system}.default
  ];
}
