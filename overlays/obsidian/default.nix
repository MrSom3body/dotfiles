(
  final: prev: {
    obsidian = prev.obsidian.overrideAttrs (oldAttrs: {
      postInstall =
        (
          oldAttrs.postInstall or ""
        )
        + ''
          wrapProgram $out/bin/obsidian \
            --prefix PATH : ${final.lib.makeBinPath [final.pandoc]}
        '';
    });
  }
)
