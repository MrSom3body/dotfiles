{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.my.media;
in
{
  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      scripts = [
        pkgs.mpvScripts.builtins.autoload
      ]
      ++ builtins.attrValues {
        inherit (pkgs.mpvScripts)
          modernz
          mpris
          thumbfast
          ;
      };

      bindings = {
        # vim bindings
        h = "no-osd seek -5";
        j = "add volume -2";
        k = "add volume 2";
        l = "no-osd seek 5";

        H = "no-osd seek -60";
        L = "no-osd seek 60";

        "Ctrl+h" = "add video-pan-x -0.1";
        "Ctrl+j" = "add video-pan-y 0.1";
        "Ctrl+k" = "add video-pan-y -0.1";
        "Ctrl+l" = "add video-pan-x 0.1";

        "Alt+h" = "playlist-prev";
        "Alt+l" = "playlist-next";

        # other
        SPACE = "cycle pause";

        q = "quit";
        Q = "quit-watch-later";

        f = "cycle fullscreen";
        ESC = "set fullscreen no";

        m = "osd-msg cycle mute";

        z = "osd-msg add sub-delay -0.1";
        Z = "osd-msg add sub-delay +0.1";

        "." = "frame-step";
        "," = "frame-back-step";

        "Ctrl++" = "add video-zoom 0.1";
        "Ctrl+-" = "add video-zoom -0.1";
        "Ctrl+0" =
          "set video-zoom 0; no-osd set panscan 0; no-osd set video-pan-x 0; no-osd set video-pan-y 0; no-osd set video-align-x 0; no-osd set video-align-y 0";

        "Ctrl+o" = "cycle-values loop-file \"inf\" \"no\"";
        "Ctrl+p" = "script-binding select/select-playlist";
        "Ctrl+c" = "script-binding select/select-chapter";

        "Alt+v" = "script-binding select/select-vid";
        "Alt+a" = "script-binding select/select-aid";
        "Alt+s" = "script-binding select/select-sid";

        i = "script-binding stats/display-stats";
        I = "script-binding stats/display-stats-toggle";
        "?" = "script-binding select/select-binding";

        # mouse
        MBTN_LEFT = "ignore";
        MBTN_LEFT_DBL = "cycle fullscreen";
        MBTN_RIGHT = "cycle pause";
        MBTN_BACK = "playlist-prev";
        MBTN_FORWARD = "playlist-next";

        WHEEL_UP = "add volume 2";
        WHEEL_DOWN = "add volume -2";
        WHEEL_LEFT = "no-osd seek -10";
        WHEEL_RIGHT = "no-osd seek 10";
      };

      config = {
        # general
        osc = false;
        input-default-bindings = false;
        keep-open = true;
        profile = "high-quality";

        cursor-autohide = 1000;

        # terminal
        msg-color = true;
        msg-module = true;
        term-osd-bar = true;

        # cache
        cache = true;
        demuxer-max-bytes = "256MiB";
        demuxer-max-back-bytes = "128MiB";

        # video
        hwdec = false;
        vo = "gpu-next";
        gpu-api = "opengl";

        # copied from https://kokomins.wordpress.com/2019/10/14/mpv-config-guide/#video-config
        deband = true;
        deband-iterations = 2; # Range 1-16. Higher = better quality but more GPU usage. >5 is redundant.
        deband-threshold = 35; # Range 0-4096. Deband strength.
        deband-range = 20; # Range 1-64. Range of deband. Too high may destroy details.
        deband-grain = 5; # Range 0-4096. Inject grain to cover up bad banding, higher value needed for poor sources.

        video-sync = "display-resample";
        interpolation = "yes";

        # audio
        audio-file-auto = "fuzzy";
        volume = 50;
        volume-max = 100;

        # subtitles
        sub-fix-timing = true;
        sub-auto = "fuzzy"; # fuzzy select subs
        blend-subtitles = true;
        demuxer-mkv-subtitle-preroll = true; # force showing subtitles while seeking

        # priorities
        alang = "ja,jp,jpn,en,eng,de,deu,ger";
        slang = "en,eng,de,deu,ger";

        # screenshot
        screenshot-format = "png";
        screenshot-high-bit-depth = "yes";
        screenshot-directory = "~/Pictures/mpv";
      };

      scriptOpts = {
        autoload.directory_mode = "ignore";
        modernz = {
          # display
          greenandgrumpy = true;

          # osc behavior and scaling
          fadein = true;
          minmousemove = 10;
          bottomhover = false;
          osc_on_seek = true;
          osc_on_start = true;

          # buttons display
          ontop_button = false;
          speed_button = true;
          fullscreen_button = false;
        };
      };
    };
  };
}
