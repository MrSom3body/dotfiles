{
  flake.modules.homeManager."hosts/promethea" =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland.settings.permission = [
        ### Keyboards ###
        "video-bus, keyboard, allow"
        "asus-wmi-hotkeys, keyboard, allow"
        "at-translated-set-2-keyboard, keyboard, allow"

        # Logitech
        "logitech-usb-receiver, keyboard, allow"
        "logitech-usb-receiver-consumer-control, keyboard, allow"
        "logitech-usb-receiver-system-control, keyboard, allow"

        # Mechanical Keyboard
        "sonix-usb-device-system-control, keyboard, allow"
        "sonix-usb-device, keyboard, allow"
        "sonix-usb-device-keyboard, keyboard, allow"
        "sonix-usb-device-consumer-control, keyboard, allow"

        # Wacom Tablet
        "opentabletdriver-virtual-keyboard, keyboard, allow"

        # Deny everything else
        ".*, keyboard, deny"
      ];

      home.packages = builtins.attrValues {
        inherit (pkgs)
          # cli
          glow
          # proton
          proton-authenticator
          proton-pass
          protonvpn-gui
          # misc
          exercism
          fragments
          pika-backup
          ;
      };
    };
}
