{...}: {
  services.asusd = {
    enable = true;
    asusdConfig = ''
      (
          charge_control_end_threshold: 75,
          panel_od: false,
          boot_sound: false,
          mini_led_mode: false,
          disable_nvidia_powerd_on_battery: true,

          ac_command: "",
          bat_command: "",

          change_throttle_policy_on_battery: true,
          change_throttle_policy_on_ac: true,
          throttle_policy_linked_epp: true,

          throttle_policy_on_battery: Quiet,
          throttle_policy_on_ac: Performance,
          throttle_quiet_epp: Power,
          throttle_balanced_epp: BalancePower,
          throttle_performance_epp: Performance,
      )
    '';
  };
  services.supergfxd.enable = true;
}
