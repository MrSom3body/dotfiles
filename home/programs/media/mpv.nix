{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    scripts =
      (with pkgs.mpvScripts.builtins; [autoload])
      ++ (with pkgs.mpvScripts; [
        mpris
        evafast
      ]);
    config = {
      # general
      keep-open = true;
      save-position-on-quit = true;
      profile = "high-quality";

      # priorities
      alang = "ja,jp,jpn,en,eng,de,deu,ger";
      slang = "en,eng,de,deu,ger";

      # video
      vo = "gpu-next";
      gpu-api = "vulkan";
      hwdec = "auto";

      # subtitles
      demuxer-mkv-subtitle-preroll = true; # force showing subtitles while seeking
      blend-subtitles = true;
      sub-fix-timing = true;
      sub-auto = "fuzzy"; # fuzzy select subs

      # interpolation
      video-sync = "display-resample";
      interpolation = "yes";
    };
    scriptOpts = {
      autoload.directory_mode = "ignore";
    };
  };
}
