{
  flake.modules.nixos.printing =
    { pkgs, ... }:
    {
      services.printing = {
        enable = true;
        drivers = builtins.attrValues {
          inherit (pkgs)
            cups-filters
            cups-browsed
            ;
        };
      };
    };
}
