{
  outputs,
  pkgs,
  ...
}: {
  auto-kbd-bl = pkgs.callPackage ./auto-kbd-bl {};
  fuzzel-goodies = pkgs.callPackage ./fuzzel-goodies {};
  gns3-auto-conf = pkgs.callPackage ./gns3-auto-conf {};
  hyprcast = pkgs.callPackage ./hyprcast {};
  power-monitor = pkgs.callPackage ./power-monitor {};
  wl-ocr = pkgs.callPackage ./wl-ocr {};
  default = outputs.nixosConfigurations.sanctuary.config.system.build.isoImage;
}
