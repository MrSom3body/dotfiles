{ self, lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { config, pkgs, ... }:
    {
      wayland.windowManager.hyprland.settings =
        let
          swayosd = lib.getExe' config.services.swayosd.package "swayosd-client";
        in
        {
          bindl =
            let
              playerctl = lib.getExe config.services.playerctld.package;
            in
            [
              # Audio control
              ", XF86AudioPlay, exec, ${playerctl} play-pause"
              ", XF86AudioPause, exec, ${playerctl} play-pause"
              ", XF86AudioNext, exec, ${playerctl} next"
              ", XF86AudioPrev, exec, ${playerctl} previous"
              ", XF86AudioMute, exec, ${swayosd} --output-volume mute-toggle"
              ", XF86AudioMicMute, exec, ${swayosd} --output-input mute-toggle"
            ];

          bindlr = [
            # Touchpad toggle
            ", XF86TouchpadToggle, exec, ${
              lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.touchpad-toggle
            }"

            # Caps Lock
            ", Caps_Lock, exec, ${swayosd} --caps-lock"

            # Num Lock
            ", Num_Lock, exec, ${swayosd} --num-lock"
          ];

          bindel = [
            # Volume control
            ", XF86AudioRaiseVolume, exec, ${swayosd} --output-volume raise"
            ", XF86AudioLowerVolume, exec, ${swayosd} --output-volume lower"
            "ALT, XF86AudioRaiseVolume, exec, ${swayosd} --output-volume +1"
            "ALT, XF86AudioLowerVolume, exec, ${swayosd} --output-volume -1"

            # Brightness control
            ", XF86MonBrightnessUp, exec, ${swayosd} --brightness raise"
            ", XF86MonBrightnessDown, exec, ${swayosd} --brightness lower"
            "ALT, XF86MonBrightnessUp, exec, ${swayosd} --brightness +1"
            "ALT, XF86MonBrightnessDown, exec, ${swayosd} --brightness -1"
          ];
        };
    };
}
