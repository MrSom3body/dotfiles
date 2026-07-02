{
  flake.modules.nixos.nixos = {
    boot.kernel.sysfs.module.zswap.parameters = {
      enabled = 1;
      compressor = "zstd";
      max_pool_percent = 20;
      shrinker_enabled = 1;
    };
  };
}
