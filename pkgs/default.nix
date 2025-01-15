{pkgs, ...}: {
  wl-ocr = pkgs.callPackage ./wl-ocr {};
  hyprcast = pkgs.callPackage ./hyprcast {};
}
