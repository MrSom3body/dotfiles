{
  flake.modules.homeManager.adb =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.android-tools ];
    };
}
