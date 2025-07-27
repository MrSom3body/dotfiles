{
  config,
  pkgs,
  ...
}:
{
  imports = [ ./fail2ban.nix ];

  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      # https://infosec.mozilla.org/guidelines/openssh.html
      KexAlgorithms = [
        "curve25519-sha256@libssh.org"
        "ecdh-sha2-nistp521"
        "ecdh-sha2-nistp384"
        "ecdh-sha2-nistp256"
        "diffie-hellman-group-exchange-sha256"
      ];
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
        "hmac-sha2-512"
        "hmac-sha2-256"
        "umac-128@openssh.com"
      ];
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      LogLevel = "VERBOSE";
    };
    moduliFile = pkgs.runCommand "filterModuliFile" { } ''
      awk '$5 >= 3071' "${config.programs.ssh.package}/etc/ssh/moduli" >"$out"
    '';
  };
}
