{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.programs.macchina;
in {
  config = mkIf cfg.enable {
    home.file.".config/macchina/themes/default.toml".text =
      # toml
      ''
        spacing = 2
        padding = 0
        hide_ascii = true
        prefer_small_ascii = false
        separator = ""
        key_color = "Green"
        separator_color = "Green"

        [palette]
        type = "Dark"
        glyph = "  "
        visible = true

        [bar]
        glyph = ""
        symbol_open = '['
        symbol_close = ']'
        visible = false
        hide_delimiters = true

        [box]
        title = ""
        border = "round"
        visible = false

        [box.inner_margin]
        x = 1
        y = 0

        [randomize]
        key_color = false
        separator_color = false
        pool = "base"

        [keys]
        distro = "󰌽  Distro"
        host = "  Host"
        kernel = "  Kernel"
        uptime = "  Uptime"
        packages = "󰏖  Packages"
        shell = "  Shell"
        de = "󰧨  DE/WM"
        terminal = "  Term"
        cpu = "  CPU"
        cpu_load = "  CPU %"
        gpu = "󰟽 GPU"
        memory = "  Memory"
        disk_space = "󰨣  Disk Space"
        local_ip = "  Local IP"
        backlight = "󰃠  Brightness"
        battery = "󰁹  Battery"
      '';
  };
}
