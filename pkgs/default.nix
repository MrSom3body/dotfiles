{pkgs, ...}: {
  wl-ocr = pkgs.callPackage ./wl-ocr {};
  hyprcast = pkgs.callPackage ./hyprcast {};
  fuzzel-goodies = pkgs.callPackage ./fuzzel-goodies {};
}
