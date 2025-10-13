{
  flake.modules.nixos.wireshark =
    { pkgs, ... }:
    {
      programs.wireshark = {
        enable = true;
        package = pkgs.wireshark;
      };

      users.users.karun.extraGroups = [ "wireshark" ];
    };
}
