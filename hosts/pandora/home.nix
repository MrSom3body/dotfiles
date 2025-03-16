{pkgs, ...}: {
  imports = [
    ../../home/profiles/server.nix

    # system services
    ../../home/services/system/rclone.nix
    ../../home/services/system/syncthing.nix
  ];

  systemd.user = {
    services.build-iso = {
      Unit.Description = "Build NixOS ISO";
      Service = {
        ExecStart = let
          buildISO = pkgs.writeScript "buildISO" ''
            #!${pkgs.fish}/bin/fish
            nix run nixpkgs#nix-fast-build -- --flake github:MrSom3body/dotfiles#packages.x86_64-linux.default \
              --skip-cached \
              --no-nom
            mkdir -p ~/ISOs
            mv result-/iso/*.iso ~/ISOs/nixos-minimal-$(date +%Y-%m-%dT%H:%M).iso
            rm result-
          '';
        in
          buildISO;
      };
    };

    timers.build-iso = {
      Unit.Description = "Build NixOS ISO timer";
      Timer = {
        OnCalendar = "weekly";
        Unit = "build-iso.service";
        Persistent = true;
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
