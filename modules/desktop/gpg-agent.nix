{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
    };
}
