# Initial setup (one-time, after first deploy):
#
#   sudo -u protonvpn env \
#     HOME=/var/lib/protonvpn \
#     XDG_CONFIG_HOME=/var/lib/protonvpn/.config \
#     XDG_RUNTIME_DIR=/var/lib/protonvpn/run \
#     dbus-run-session protonvpn signin

{
  flake.modules.nixos.arr =
    { pkgs, ... }:
    let
      vpnHome = "/var/lib/protonvpn";
    in
    {
      systemd.tmpfiles.rules = [ "d ${vpnHome}/run 0700 protonvpn protonvpn -" ];

      users = {
        users.protonvpn = {
          isSystemUser = true;
          group = "protonvpn";
          home = vpnHome;
          createHome = true;
          extraGroups = [ "networkmanager" ];
        };
        groups.protonvpn = { };
      };

      # Allow the protonvpn system user to manage NetworkManager connections
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.user === "protonvpn" &&
              action.id.indexOf("org.freedesktop.NetworkManager") === 0) {
            return polkit.Result.YES;
          }
        });
      '';

      systemd.services.protonvpn = {
        description = "ProtonVPN Connection";
        after = [
          "network-online.target"
          "NetworkManager.service"
        ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          HOME = vpnHome;
          XDG_CONFIG_HOME = "${vpnHome}/.config";
          XDG_RUNTIME_DIR = "${vpnHome}/run";
        };
        path = [
          pkgs.dbus
          pkgs.proton-vpn-cli
        ];
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "30s";
          User = "protonvpn";
          Group = "protonvpn";
          ExecStartPre = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.proton-vpn-cli}/bin/protonvpn config set port-forwarding on";
          ExecStart = pkgs.writeShellScript "protonvpn-watchdog" ''
            dbus-run-session protonvpn connect --p2p
            while true; do
              sleep 60
              dbus-run-session protonvpn status | grep -q "Connected" || \
                dbus-run-session protonvpn connect --p2p
            done
          '';
          ExecStop = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.proton-vpn-cli}/bin/protonvpn disconnect";
        };
      };

      environment.systemPackages = [ pkgs.proton-vpn-cli ];
    };
}
