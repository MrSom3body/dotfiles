{ lib, config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules = {
    nixos.desktop =
      { pkgs, ... }:
      {
        xdg.portal = {
          enable = true;
          xdgOpenUsePortal = true;
          config = {
            common.default = [ "gtk" ];
            hyprland.default = [
              "gtk"
              "hyprland"
            ];
          };

          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
          ];
        };
      };

    homeManager.desktop =
      { config, pkgs, ... }:
      let
        browser = [ "zen.desktop" ];
        imageViewer = [ "org.gnome.Loupe.desktop" ];
        videoPlayer = [ "mpv.desktop" ];
        audioPlayer = [ "io.bassi.Amberol.desktop" ];

        xdgAssociations =
          type: list: program:
          builtins.listToAttrs (
            map (e: {
              name = "${type}/${e}";
              value = program;
            }) list
          );

        images = xdgAssociations "image" [ "png" "svg" "jpeg" "gif" "heif" ] imageViewer;
        audios = xdgAssociations "audio" [ "mp3" "flac" "wav" "aac" ] audioPlayer;
        videos = xdgAssociations "video" [ "mp4" "avi" "mkv" ] videoPlayer;

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
          ] browser)
          // (xdgAssociations "x-scheme-handler" [
            "about"
            "chrome"
            "ftp"
            "http"
            "https"
            "mailto"
            "unknown"
          ] browser);
      in
      {
        xdg = {
          mimeApps = {
            enable = true;
            defaultApplications = {
              "application/pdf" = [ "org.pwmt.zathura.desktop" ]; # PDFs
              "application/zip" = [ "yazi.desktop" ]; # ZIPs
              "inode/directory" = [ "yazi.desktop" ]; # Files
              "text/html" = browser; # HTML files
              "text/plain" = [ "Helix.desktop" ]; # Plain text
            }
            // images
            // audios
            // videos
            // browserTypes;
            associations.removed =
              let
                noCalibre =
                  let
                    mimeTypes = [
                      "application/pdf"
                      "application/vnd.oasis.opendocument.text"
                      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                      "text/html"
                      "text/plain"
                      "text/x-markdown"
                    ];
                    desktopFiles = [
                      "calibre-ebook-edit.desktop"
                      "calibre-ebook-viewer.desktop"
                      "calibre-gui.desktop"
                    ];
                  in
                  lib.zipAttrs (map (d: lib.genAttrs mimeTypes (_: d)) desktopFiles);
              in
              noCalibre;
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
          pkgs.xdg-utils
          (pkgs.writeShellScriptBin "xdg-terminal-exec" ''
            ${meta.programs.terminal} -e "$@"
          '')
        ];
      };
  };
}
