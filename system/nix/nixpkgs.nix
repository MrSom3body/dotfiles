{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    overlays = [
      (import ../../overlays/vpnc)
    ];
  };
}
