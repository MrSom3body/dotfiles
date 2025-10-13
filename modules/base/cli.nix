{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = builtins.attrValues {
        inherit (pkgs)
          # archives
          zip
          unzip
          # downloading
          wget
          ;
      };
    };
}
