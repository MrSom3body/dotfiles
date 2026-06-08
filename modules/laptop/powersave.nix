{
  flake.modules.nixos.laptop = { lib, ... }: {
    services.logind.settings.Login =
      let
        action = "suspend-then-hibernate";
      in
      {
        HandleLidSwitch = lib.mkDefault action;
        HandlePowerKey = lib.mkDefault action;
      };

    systemd = {
      sleep.settings.Sleep = {
        HibernateDelaySec = "1h";
        HibernateMode = "shutdown";
      };

      # copied from @fufexan and powertop
      services.powersave = {
        enable = true;
        description = "Apply power saving tweaks";
        wantedBy = [ "multi-user.target" ];
        script = ''
          echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
          echo 1 > /sys/module/snd_hda_intel/parameters/power_save
          echo 0 > /proc/sys/kernel/nmi_watchdog

          for i in /sys/bus/pci/devices/*; do
            echo auto > "$i/power/control"
          done
        '';
      };
    };
  };
}
