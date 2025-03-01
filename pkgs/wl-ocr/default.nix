# copied from @fufexan
{
  lib,
  writeShellScriptBin,
  grim,
  slurp,
  tesseract,
  wl-clipboard,
  libnotify,
}: let
  _ = lib.getExe;
in
  writeShellScriptBin "wl-ocr" ''
    ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract} -l eng+deu - - | ${wl-clipboard}/bin/wl-copy
    echo "$(${wl-clipboard}/bin/wl-paste)"
    ${_ libnotify} -t 3000 -i ocrfeeder -- "wl-ocr" "$(${wl-clipboard}/bin/wl-paste)"
  ''
