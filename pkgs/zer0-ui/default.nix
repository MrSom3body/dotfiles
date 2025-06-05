{
  inputs,
  pkgs,
  ...
}:
inputs.ags.lib.bundle {
  inherit pkgs;
  src = ./.;
  name = "zer0-ui";
  entry = "app.ts";
  gtk4 = false;

  extraPackages = [
    inputs.ags.packages.${pkgs.system}.battery
    pkgs.fzf
  ];
}
