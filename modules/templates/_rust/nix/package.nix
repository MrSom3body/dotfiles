{ self, ... }: {
  perSystem = { pkgs, ... }: {
    packages.rust-hello = pkgs.rustPlatform.buildRustPackage {
      pname = "rust-hello";
      version = builtins.substring 0 8 self.lastModifiedDate;
      src = ../.;

      cargoLock.lockFile = ../Cargo.lock;
    };
  };
}
