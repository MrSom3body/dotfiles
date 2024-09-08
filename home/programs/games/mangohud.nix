{config, ...}: {
  programs.mangohud = {
    enable = true;
    settings = {
      toggle_fps_limit = "F1";

      legacy_layout = false;
      gpu_stats = true;
      gpu_temp = true;
      gpu_load_change = true;
      gpu_load_value = "50,90";
      gpu_text = "GPU";
      cpu_stats = true;
      cpu_temp = true;
      cpu_load_change = true;
      core_load_change = true;
      cpu_load_value = "50,90";
      cpu_text = "CPU";
      vram = true;
      ram = true;
      fps = true;
      frame_timing = 1;
      media_player = true;

      position = "top-left";
      round_corners = 0;
      toggle_hud = "Shift_R+F12";
      toggle_logging = "Shift_L+F2";
      upload_log = "F5";
      output_folder = config.home.homeDirectory;
      media_player_name = "spotify";
    };
  };
}
