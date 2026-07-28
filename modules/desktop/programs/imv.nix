{
  flake.modules.homeManager.desktop = {
    programs.imv.enable = true;

    xdg.desktopEntries =
      let
        mimeTypes = [
          "image/x-farbfeld"
          "image/tiff"
          "image/tiff-fx"
          "image/png"
          "image/x-png"
          "image/jpeg"
          "image/jpg"
          "image/pjpeg"
          "image/svg+xml"
          "image/gif"
          "image/bmp"
          "image/x-bmp"
          "image/heif"
          "image/avif"
          "image/jxl"
          "image/webp"
          "image/qoi"
        ];
      in
      {
        imv-dir = {
          name = "imv-dir";
          genericName = "Image viewer";
          comment = "Fast Image Viewer | Open all images in a directory";
          exec = "imv-dir %F";
          noDisplay = false;
          terminal = false;
          type = "Application";
          categories = [
            "Graphics"
            "2DGraphics"
            "Viewer"
          ];
          mimeType = mimeTypes;
          icon = "multimedia-photo-viewer";
          settings = {
            "Name[en_US]" = "imv-dir";
            "GenericName[en_US]" = "Image viewer";
            Keywords = "photo;picture;";
          };
        };

        imv = {
          name = "imv";
          genericName = "Image viewer";
          comment = "Fast Image Viewer";
          exec = "imv %F";
          noDisplay = false;
          terminal = false;
          type = "Application";
          categories = [
            "Graphics"
            "2DGraphics"
            "Viewer"
          ];
          mimeType = mimeTypes;
          icon = "multimedia-photo-viewer";
          settings = {
            "Name[en_US]" = "imv";
            "GenericName[en_US]" = "Image viewer";
            Keywords = "photo;picture;";
          };
        };
      };
  };
}
