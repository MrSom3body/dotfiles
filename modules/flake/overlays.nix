{ inputs, ... }:
let
  nix-topology = inputs.nix-topology.overlays.default;

  modifications =
    final: prev:
    # let
    #   overrideIfOlder =
    #     pkg: expectedVersion: overrideArgs:
    #     let
    #       noOverride = final.lib.versionAtLeast pkg.version expectedVersion;
    #     in
    #     final.lib.warnIf noOverride ''
    #       ${pkg.pname or pkg.name} >= ${expectedVersion} is now in nixpkgs, the override can be removed.
    #     '' (if noOverride then pkg else pkg.overrideAttrs overrideArgs);
    # in
    {
      obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          wrapProgram $out/bin/obsidian \
            --prefix PATH : ${final.lib.makeBinPath [ final.pandoc ]}
        '';
      });
    };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  };
in
{
  flake.overlays = {
    default = inputs.nixpkgs.lib.composeManyExtensions [
      nix-topology
      modifications
      stable-packages
    ];

    inherit nix-topology modifications stable-packages;
  };
}
