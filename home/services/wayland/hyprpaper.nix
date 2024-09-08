{
  inputs,
  pkgs,
  ...
}: {
  services.hyprpaper = {
    package = inputs.hyprpaper.packages.${pkgs.system}.default;
  };
}
