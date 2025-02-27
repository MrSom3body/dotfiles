let
  overlayDir = ../../overlays;

  # Get a list of all files in moduleDir
  overlayFiles = builtins.attrNames (builtins.readDir overlayDir);

  # Import each module, assuming each file is a valid nix module
  overlays = builtins.map (name: import (overlayDir + "/${name}")) overlayFiles;
in {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    inherit overlays;
  };
}
