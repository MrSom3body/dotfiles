{ inputs, ... }:
let
  nix-topology = inputs.nix-topology.overlays.default;

  modifications =
    final: prev:
    let
      overrideIfOlder =
        pkg: expectedVersion: overrideArgs:
        let
          noOverride = final.lib.versionAtLeast pkg.version expectedVersion;
        in
        final.lib.warnIf noOverride ''
          ${pkg.pname or pkg.name} >= ${expectedVersion} is now in nixpkgs, the override can be removed.
        '' (if noOverride then pkg else pkg.overrideAttrs overrideArgs);
    in
    {
      # TODO remove when https://github.com/NixOS/nixpkgs/pull/558436 gets merged
      tsukimi = overrideIfOlder prev.tsukimi "26.9.1" (
        finalAttrs: previousAttrs: {
          version = "26.9.2";
          src = prev.fetchFromGitHub {
            owner = "tsukinaha";
            repo = "tsukimi";
            tag = "v${finalAttrs.version}";
            hash = "sha256-qlkXQxae8rhDgIJk60NzD6yk6b71S8jTGuChcnW9VuM=";
          };
          cargoDeps = prev.rustPlatform.fetchCargoVendor {
            inherit (finalAttrs) pname version src;
            hash = "sha256-Phwn2qBPVaGEyzaBHIg9vq8LEFI0DsSUWkHrpimjy30=";
          };
          nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
            prev.blueprint-compiler
            prev.libglycin.patchVendorHook
          ];
          buildInputs = previousAttrs.buildInputs ++ [
            prev.libglycin
            prev.glycin-loaders
          ];
        }
      );

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
