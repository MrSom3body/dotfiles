{
  boot.kernel.sysfs.module.zswap.parameters = {
    enabled = 1;
    compressor = "lz4";
    max_pool_percent = 20;
    shrinker_enabled = 1;
  };
}
