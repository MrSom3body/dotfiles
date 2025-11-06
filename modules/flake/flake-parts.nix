{ lib, inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  options.flake = {
    meta = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.anything;
    };
    images = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.anything;
    };
  };

  config = {
    flake.meta.uri = "github:MrSom3body/dotfiles";
  };
}
