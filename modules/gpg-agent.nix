{
  flake.modules.homeManager.gpg-agent =
    { pkgs, ... }:
    {
      programs.gpg.enable = true;

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentry.package = pkgs.pinentry-gnome3;
      };
    };
}
