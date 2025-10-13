{
  flake.modules.nixos.base = {
    services.dbus.implementation = "broker";
  };
}
