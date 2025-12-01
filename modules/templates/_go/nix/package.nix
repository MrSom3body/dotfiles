{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.go-hello = pkgs.buildGoModule {
        pname = "go-hello";
        version = builtins.substring 0 8 self.lastModifiedDate;
        src = ../.;

        vendorHash = pkgs.lib.fakeHash;
      };
    };
}
