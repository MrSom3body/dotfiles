{ inputs, ... }:
let
  nix-topology = inputs.nix-topology.overlays.default;

  modifications = final: prev: {
    obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/obsidian \
          --prefix PATH : ${final.lib.makeBinPath [ final.pandoc ]}
      '';
    });

    # TODO remove when https://github.com/NixOS/nixpkgs/issues/542586 gets resolved
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (_pyFinal: pyPrev: {
        paho-mqtt = pyPrev.paho-mqtt.overridePythonAttrs (oldAttrs: {
          disabledTests = (oldAttrs.disabledTests or [ ]) ++ [
            "test_callback_v1_mqtt3"
            "test_callback_v2_mqtt3"
            "test_03_publish_helper_qos0"
            "test_03_publish_helper_qos0_v5"
            "test_08_ssl_fake_cacert"
          ];
        });
      })
    ];
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
