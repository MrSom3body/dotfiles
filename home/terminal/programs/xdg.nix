{...}: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["org.gnome.Papers.desktop"]; # PDFs
      "application/zip" = ["org.gnome.Nautilus.desktop" "org.gnome.FileRoller.desktop"]; # ZIPs
      "image/*" = ["org.gnome.Loupe.desktop"]; # Images
      "image/jpg" = ["org.gnome.Loupe.desktop"]; # Images
      "image/jpeg" = ["org.gnome.Loupe.desktop"]; # Images
      "image/png" = ["org.gnome.Loupe.desktop"]; # Images
      "text/plain" = ["nvim.desktop"]; # Plain text
      "x-scheme-handler/http" = ["firefox.desktop"]; # Links
      "x-scheme-handler/https" = ["firefox.desktop"]; # Links
      "x-scheme-handler/mailto" = ["firefox.desktop"]; # Links
    };
  };
}
