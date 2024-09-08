{...}: {
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
