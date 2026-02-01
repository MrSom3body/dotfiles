{ inputs, ... }:
{
  flake.modules.nixos."hosts/xylourgos" = {
    imports = [ inputs.disko.nixosModules.disko ];

    disko.devices = {
      disk =
        let
          mountOptions = [
            "compress=zstd"
            "noatime"
          ];
        in
        {
          boot = {
            type = "disk";
            device = "/dev/sda";
            content = {
              type = "gpt";
              partitions = {
                ESP = {
                  size = "512M";
                  type = "EF00";
                  priority = 1;
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = [ "umask=0077" ];
                  };
                };
                root = {
                  size = "100%";
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" ];
                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";
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

          block = {
            type = "disk";
            device = "/dev/sdb";
            content = {
              type = "gpt";
              partitions = {
                primary = {
                  size = "100%";
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" ];
                    subvolumes = {
                      "/home" = {
                        mountpoint = "/home";
                        inherit mountOptions;
                      };
                      "/var/log" = {
                        mountpoint = "/var/log";
                        inherit mountOptions;
                      };
                      "/var/lib" = {
                        mountpoint = "/var/lib";
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
