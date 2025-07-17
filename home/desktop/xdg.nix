{
  lib,
  config,
  pkgs,
  settings,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.desktop.xdg;

  browser = ["zen.desktop"];
  imageViewer = ["org.gnome.Loupe.desktop"];
  videoPlayer = ["mpv.desktop"];
  audioPlayer = ["io.bassi.Amberol.desktop"];

  xdgAssociations = type: list: program:
    builtins.listToAttrs (map (e: {
        name = "${type}/${e}";
        value = program;
      })
      list);

  images = xdgAssociations "image" ["png" "svg" "jpeg" "gif" "heif"] imageViewer;
  audios = xdgAssociations "audio" ["mp3" "flac" "wav" "aac"] audioPlayer;
  videos = xdgAssociations "video" ["mp4" "avi" "mkv"] videoPlayer;

  browserTypes =
    (xdgAssociations "application" [
        "application/x-extension-htm"
        "application/x-extension-html"
        "application/x-extension-shtml"
        "application/x-extension-xht"
        "application/x-extension-xhtml"
        "application/xhtml+xml"
        "json"
        "text/html"
        "x-extension-htm"
        "x-extension-html"
        "x-extension-shtml"
        "x-extension-xht"
        "x-extension-xhtml"
        "x-scheme-handler/chrome"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "xhtml+xml"
      ]
      browser)
    // (xdgAssociations "x-scheme-handler" [
        "about"
        "chrome"
        "ftp"
        "http"
        "https"
        "mailto"
        "unknown"
      ]
      browser);
in {
  options.my.desktop.xdg = {
    enable = mkEnableOption "xdg stuff";
  };

  config = mkIf cfg.enable {
    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications =
          {
            "application/pdf" = ["org.pwmt.zathura.desktop"]; # PDFs
            "application/zip" = ["yazi.desktop"]; # ZIPs
            "inode/directory" = ["yazi.desktop"]; # Files
            "text/html" = browser; # HTML files
            "text/plain" = ["Helix.desktop"]; # Plain text
          }
          // images
          // audios
          // videos
          // browserTypes;
      };

      userDirs = {
        enable = true;
        createDirectories = true;
        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
        };
      };
    };

    home.packages = [
      # used by `gio open` and xdp-gtk
      (pkgs.writeShellScriptBin "xdg-terminal-exec" ''
        ${settings.programs.terminal} "$@"
      '')
      pkgs.xdg-utils
    ];
  };
}
