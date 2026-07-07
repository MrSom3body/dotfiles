{
  flake.modules.nixos.smartd = {
    services = {
      smartd.enable = true;
      beszel.agent.smartmon.enable = true;
    };
  };
}
