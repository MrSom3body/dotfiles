{
  pkgs,
  lib,
  ...
}: {
  home.packages = let
    _ = lib.getExe;
  in [
    (pkgs.writeShellScriptBin "wl-ocr" ''
      ${_ pkgs.grim} -g "$(${_ pkgs.slurp})" -t ppm - | ${_ pkgs.tesseract5} -l eng+deu - - | ${pkgs.wl-clipboard}/bin/wl-copy
      echo "$(${pkgs.wl-clipboard}/bin/wl-paste)"
      ${_ pkgs.libnotify} -t 3000 -i ocrfeeder -- "wl-ocr" "$(${pkgs.wl-clipboard}/bin/wl-paste)"
    '')
  ];
}
