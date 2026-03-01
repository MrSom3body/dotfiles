{ lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland = {
        settings.bindd = [ "SUPER, S, Activate system submap, submap, system" ];
        submaps.system = {
          onDispatch = "reset";
          settings = {
            bindd =
              let
                shorten = s: builtins.substring 0 14 s;
                runOnce =
                  program:
                  let
                    prog = shorten program;
                  in
                  "pgrep ${prog} || uwsm app -- ${program}";
              in
              [
                ", R, Start/stop screencast (without audio), exec, uwsm app -- hyprcast"
                "SHIFT, R, Start/stop screencast (with audio), exec, uwsm app -- hyprcast -a"

                ", O, Copy text from screen, exec, wl-ocr -nc"
                ", C, Open color picker, exec, ${runOnce "hyprpicker -a"}"
                ", V, Connect/disconnect from a vpnc VPN, exec, vicinae-vpnc"
                ", D, Open display manager, exec, vicinae-monitors"

                "SHIFT, minus, Reset zoom, exec, hyprctl -q keyword cursor:zoom_factor 1"
              ];

            bindde =
              let
                jq = lib.getExe pkgs.jq;
              in
              [
                ", plus, Zoom in, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | ${jq} '.float * 1.1')"
                ", minus, Zoom out, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | ${jq} '(.float * 0.9) | if . < 1 then 1 else . end')"
              ];

            bindr = [ ", catchall, submap, reset" ];
          };
        };
      };
    };
}
