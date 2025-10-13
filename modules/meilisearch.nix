{
  flake.modules.nixos.meilisearch =
    { pkgs, ... }:
    {
      services.meilisearch = {
        enable = true;
        package = pkgs.meilisearch;
        settings.env = {
          MEILI_EXPERIMENTAL_DUMPLESS_UPGRADE = true;
        };
      };
    };
}
