{ inputs, ... }:
{
  flake.modules.nixos."hosts/promethea" = {
    imports = [
      inputs.disko.nixosModules.disko
    ];

    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/nvme0n1";
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
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted";
                  settings.allowDiscards = true;
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
                          swap.swapfile.size = "32G";
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
  };
}
