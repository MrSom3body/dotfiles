{
  inputs,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.system}.default;
    settings = {
      cursor-style = "bar";
      cursor-style-blink = true;
      gtk-single-instance = true;
      mouse-hide-while-typing = true;
      window-decoration = false;
      window-padding-balance = true;
      window-padding-x = 15;
      window-padding-y = 15;
      font-feature = [
        "cv01"
        "cv02"
        "ss01"
        "cv14"
        "cv18"
        "ss06"
      ];
    };
  };
}
