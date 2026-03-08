{ inputs, ... }:
{
  flake.overlays = {
    # from inputs
    hyprnix = inputs.hyprnix.overlays.default;
    nix-topology = inputs.nix-topology.overlays.default;

    # my overlays
    modifications = final: prev: {
      obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          wrapProgram $out/bin/obsidian \
            --prefix PATH : ${final.lib.makeBinPath [ final.pandoc ]}
        '';
      });

      # TODO remove when https://github.com/helix-editor/helix/pull/15407 lands in master
      helix = prev.helix.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [ ./helix.patch ];
      });

      # TODO remove when https://github.com/NixOS/nixpkgs/pull/496839 gets merged into nixos-unstable
      libvirt = prev.libvirt.overrideAttrs (oldAttrs: {
        postPatch =
          (oldAttrs.postPatch or "")
          + (final.lib.optionalString final.stdenv.hostPlatform.isLinux (
            let
              script = final.writeShellApplication {
                name = "virt-secret-init-encryption-sh";
                runtimeInputs = [
                  final.coreutils
                  final.systemd
                ];
                text = ''exec ${final.runtimeShell} "$@"'';
              };
            in
            ''
              substituteInPlace src/secret/virt-secret-init-encryption.service.in \
                --replace-fail /usr/bin/sh ${script}/bin/virt-secret-init-encryption-sh
            ''
          ));
      });
    };

    stable-packages = final: _prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    };
  };
}
