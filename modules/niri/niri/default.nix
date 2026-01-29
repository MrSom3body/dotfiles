{ inputs, ... }:
{
  flake.modules = {
    nixos.niri =
      { pkgs, ... }:
      {
        programs.niri.enable = true;
        environment.systemPackages = with pkgs; [
          xwayland-satellite # for xwayland support
        ];
      };

    homeManager.niri = {
      imports = [
        inputs.niri-flake.homeModules.default
      ];

      services.network-manager-applet.enable = true;

      programs.niri = {
        enable = true;
      };
    };
  };
}
