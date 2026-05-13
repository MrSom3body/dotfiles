{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { lib, config, ... }:
    {
      imports = [ inputs.tailray.homeManagerModules.default ];
      services.tailray = {
        enable = true;
        theme = config.stylix.polarity;
      };
      systemd.user.services.tailray = {
        Unit.After = lib.mkForce "graphical-session.target";
      };
    };
}
