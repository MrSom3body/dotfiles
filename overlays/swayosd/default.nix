(
  final: prev: {
    swayosd = prev.swayosd.overrideAttrs (
      _oldAttrs: rec {
        version = "v0.1.0";

        src = final.fetchFromGitHub {
          owner = "ErikReider";
          repo = "SwayOSD";
          rev = version;
          hash = "sha256-GyvRWEzTxQxTAk+xCLFsHdd1SttBliOgJ6eZqAxQMME=";
        };

        cargoDeps = final.rustPlatform.fetchCargoTarball {
          inherit src;
          name = "swayosd-${version}";
          hash = "sha256-Tvalky7EDyJhwT4dJ8i85/QKpCVKGpb6y5EIRKygMXs=";
        };
      }
    );
  }
)
