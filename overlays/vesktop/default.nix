(_: prev: {
  vesktop = prev.vesktop.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [./disableAutoGain.patch];
  });
})
