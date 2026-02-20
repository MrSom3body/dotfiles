{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;

        extraPackages = builtins.attrValues { inherit (pkgs) libva libva-vdpau-driver libvdpau-va-gl; };
        extraPackages32 = builtins.attrValues { inherit (pkgs) libva-vdpau-driver libvdpau-va-gl; };
      };
    };
}
