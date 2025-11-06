{
  flake.modules.nixos.nixos = {
    services.dbus.implementation = "broker";
  };
}
