{
  flake.modules.nixos.server = {
    services.borgmatic.settings.source_directories = [ "/var/lib" ];
  };
}
