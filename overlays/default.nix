{ inputs, ... }:
{
  modifications = final: prev: {
    obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/obsidian \
          --prefix PATH : ${final.lib.makeBinPath [ final.pandoc ]}
      '';
    });

    # TODO remove when https://github.com/NixOS/nixpkgs/issues/438260 gets resolved
    gns3-server = prev.gns3-server.overrideAttrs (_oldAttrs: {
      disabledTestPaths = [
        "tests/controller/test_project.py"
      ];
    });
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
