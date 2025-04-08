{
  outputs,
  pkgs,
  ...
}: {
  fuzzel-goodies = pkgs.callPackage ./fuzzel-goodies {};
  hyprcast = pkgs.callPackage ./hyprcast {};
  power-monitor = pkgs.callPackage ./power-monitor {};
  wl-ocr = pkgs.callPackage ./wl-ocr {};
  default = outputs.nixosConfigurations.nixos.config.system.build.isoImage;
}
