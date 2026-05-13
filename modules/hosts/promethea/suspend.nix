{
  flake.modules.nixos."hosts/promethea" = {
    # TODO remove when hibernation with nvidia works again
    services.logind.settings.Login =
      let
        action = "suspend";
      in
      {
        HandleLidSwitch = action;
        HandlePowerKey = action;
      };

  };
}
