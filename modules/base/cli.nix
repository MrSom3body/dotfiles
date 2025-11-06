{
  flake.modules.nixos.nixos =
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
