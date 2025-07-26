{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_250GB_S3YJNF0JC14829N";
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
                  };
                };
            };
          };
        };
      };

      media = {
        type = "disk";
        device = "/dev/disk/by-id/ata-TOSHIBA_DT01ACA050_95GHSX9AS";
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
}
