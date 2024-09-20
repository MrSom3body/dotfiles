{pkgs, ...}: {
  home.packages = with pkgs; [macchina];

  imports = [
    ./theme.nix
  ];

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
        "Backlight",
        "Kernel",
        "Distribution",
        "DesktopEnvironment",
        "Packages",
        "LocalIP",
        "Shell",
        "Uptime",
        "Processor",
        "Memory",
      ]
    '';
}
