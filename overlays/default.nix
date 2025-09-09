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

    # TODO remove when https://github.com/NixOS/nixpkgs/pull/440668 lands in nixos-unstable
    ollama = prev.ollama.overrideAttrs (
      _oldAttrs:
      let
        version = "0.11.10";
      in
      {
        inherit version;

        src = final.fetchFromGitHub {
          owner = "ollama";
          repo = "ollama";
          tag = "v${version}";
          hash = "sha256-F5Us1w+QCnWK32noi8vfRwgMofHP9vGiRFfN2UAf1vw=";
        };
      }
    );
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
