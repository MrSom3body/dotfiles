{ inputs, ... }: {
  flake.modules.nixos."hosts/pandora" = {
    imports = [ inputs.disko.nixosModules.disko ];

    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/vda";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content =
                  let
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  in
                  {
                    type = "btrfs";

                    extraArgs = [ "-f" ];
                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";
                        inherit mountOptions;
                      };
                      "/home" = {
                        mountpoint = "/home";
                        inherit mountOptions;
                      };
                      "/nix" = {
                        mountpoint = "/nix";
                        inherit mountOptions;
                      };
                      "/swap" = {
                        mountpoint = "/swap";
                        swap.swapfile.size = "8G";
                      };
                    };
                  };
              };
            };
          };
        };

        media = {
          type = "disk";
          device = "/dev/vdb";
          content = {
            type = "gpt";
            partitions = {
              root = {
                size = "100%";
                content =
                  let
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  in
                  {
                    type = "btrfs";

                    extraArgs = [ "-f" ];
                    subvolumes = {
                      "/media" = {
                        mountpoint = "/media";
                        inherit mountOptions;
                      };
                    };
                  };
              };
            };
          };
        };
      };
    };
  };
}
