{pkgs, ...}: {
  auto-kbd-bl = pkgs.callPackage ./auto-kbd-bl {};
  fnott-dnd = pkgs.callPackage ./fnott-dnd {};
  fuzzel-goodies = pkgs.callPackage ./fuzzel-goodies {};
  gns3-auto-conf = pkgs.callPackage ./gns3-auto-conf {};
  hyprcast = pkgs.callPackage ./hyprcast {};
  power-monitor = pkgs.callPackage ./power-monitor {};
  wl-ocr = pkgs.callPackage ./wl-ocr {};
}
