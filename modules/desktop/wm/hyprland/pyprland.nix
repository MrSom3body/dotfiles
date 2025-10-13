{ inputs, ... }:
{
  flake.modules.homeManager.desktop = {
    home.packages = [
      inputs.pyprland.packages."x86_64-linux".pyprland
    ];

    home.file.".config/hypr/pyprland.toml".text =
      # toml
      ''
        [pyprland]
        plugins = ["magnify"]
      '';

    wayland.windowManager.hyprland.settings =
      let
        zoomFactor = "0.5";
      in
      {
        exec-once = [
          "pypr"
        ];

        bindd = [
          "$mainMod, plus, Zoom in, exec, pypr zoom ++${zoomFactor}"
          "$mainMod, minus, Zoom out, exec, pypr zoom --${zoomFactor}"
        ];
      };
  };
}
