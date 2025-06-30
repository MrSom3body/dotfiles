{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib) mkEnableOption;
  cfg = config.my.terminal.programs.macchina;
in {
  options.my.terminal.programs.macchina = {
    enable = mkEnableOption "macchina";
  };

  imports = [
    ./theme.nix
  ];

  config = mkIf cfg.enable {
    home.packages = [pkgs.macchina];

    home.file.".config/macchina/macchina.toml".text =
      # toml
      ''
        interface = "wlp2s0"
        long_uptime = true
        long_shell = false
        long_kernel = false
        current_shell = true
        physical_cores = true
        theme = "default"

        show = [
          "Distribution",
          # "Host",
          "Kernel",
          "Uptime",
          # "Packages",
          "Shell",
          "DesktopEnvironment",
          # "Terminal",
          # "Processor",
          # "GPU",
          "Memory",
          "DiskSpace",
          "LocalIP",
          # "Backlight",
          # "Battery",
        ]
      '';
  };
}
