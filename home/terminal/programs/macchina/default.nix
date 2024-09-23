{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (macchina.overrideAttrs (oldAttrs: rec {
      version = "6.2.1";

      src = fetchFromGitHub {
        owner = "Macchina-CLI";
        repo = oldAttrs.pname;
        rev = "v${version}";
        hash = "sha256-v1EaC4VBOvZFL2GoKlTDBMjSe8+4bxaLFvy2V7e7RW4=";
      };

      cargoDeps = oldAttrs.cargoDeps.overrideAttrs (lib.const {
        name = "${oldAttrs.pname}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-Mv+zfzGVmdmh0TdgJpqqBxVIDY0IHA5ptL+Ii05p8d4=";
      });
    }))
  ];

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
        "Distribution",
        "Host",
        "Kernel",
        "Uptime",
        "Packages",
        "Shell",
        "DesktopEnvironment",
        "Terminal",
        "Processor",
        "GPU",
        "Memory",
        "DiskSpace",
        "LocalIP",
        # "Backlight",
        # "Battery",
      ]
    '';
}
