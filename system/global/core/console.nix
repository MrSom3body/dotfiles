{
  console = {
    earlySetup = true;
    useXkbConfig = true;
  };

  services.xserver.xkb = {
    layout = "at";
    options = "caps:swapescape";
  };
}
