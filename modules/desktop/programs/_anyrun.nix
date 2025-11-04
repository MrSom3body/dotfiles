{ lib, inputs, ... }:
{
  flake.modules.homeManager.desktop =
    {
      osConfig ? null,
      config,
      pkgs,
      ...
    }:
    {
      home.packages = [
        inputs.som3pkgs.packages.${pkgs.stdenv.hostPlatform.system}.dmenu-goodies
        (pkgs.writeShellScriptBin "dmenu" ''anyrun --plugins stdin --show-results-immediately true'')
      ];

      programs.anyrun = {
        enable = true;
        package = pkgs.anyrun;
        config = {
          width.fraction = 0.3;
          x.fraction = 0.5;
          y.fraction = 0.2;
          maxEntries = 10;
          hidePluginInfo = true;
          closeOnClick = true;

          plugins =
            let
              inherit (config.programs.anyrun) package;
            in
            [
              "${package}/lib/libapplications.so"
              "${package}/lib/libdictionary.so"
              "${package}/lib/librandr.so"
              "${package}/lib/librink.so"
              "${package}/lib/libshell.so"
              "${package}/lib/libstdin.so"
              "${package}/lib/libsymbols.so"
              "${package}/lib/libtranslate.so"
              "${package}/lib/libwebsearch.so"
            ];
        };

        extraConfigFiles = {
          "applications.ron".text =
            let
              preprocessScript = pkgs.writeShellScriptBin "anyrun-preprocess-application-exec" ''
                shift
                echo "uwsm app -- $*"
              '';
            in
            # ron
            ''
              Config(
                desktop_actions: true,
                max_entries: 10,
                terminal: Some(Terminal(
                  command: "xdg-terminal-exec",
                  args: "{}"
                )),
                ${lib.optionalString (osConfig.programs.uwsm.enable or false
                ) "preprocess_exec_script: Some(\"${lib.getExe preprocessScript}\"),"}
              )
            '';

          "shell.ron".text = # ron
            ''
              Config(
                prefix: ">",
              )
            '';

          "symbols.ron".text = # ron
            ''
              Config(
                prefix: ":sy",
                symbols: {
                  // "name": "text to be copied"
                  "shrug": "¯\\_(ツ)_/¯",
                },
                max_entries: 10,
              )
            '';

          "randr.ron".text = # ron
            ''
              Config(
                prefix: ":ra",
                max_entries: 10,
              )
            '';

          "translate.ron".text = # ron
            ''
              Config(
                prefix: ":tr",
                language_delimiter: ">",
                max_entries: 5,
              )
            '';

          "stdin.ron".text = # ron
            ''
              Config(
                max_entries: 10,
              )
            '';

          "websearch.ron".text = # ron
            ''
              Config(
                prefix: "?",
                engines: [DuckDuckGo],
              )
            '';
        };

        extraCss = # css
          ''
            window {
              background: transparent;
            }

            box.main {
              padding: 5px;
              margin: 10px;
              border-radius: 10px;
              border: 2px solid @theme_selected_bg_color;
              background-color: @theme_bg_color;
              box-shadow: 0 0 5px black;
            }


            text {
              min-height: 30px;
              padding: 5px;
              border-radius: 5px;
            }

            .matches {
              background-color: rgba(0, 0, 0, 0);
              border-radius: 10px;
            }

            box.plugin:first-child {
              margin-top: 5px;
            }

            box.plugin.info {
              min-width: 200px;
            }

            list.plugin {
              background-color: rgba(0, 0, 0, 0);
            }

            label.match.description {
              font-size: 0.8em;
            }

            label.plugin.info {
              font-size: 1.2em;
            }

            .match {
              background: transparent;
            }

            .match:selected {
              border-left: 4px solid @theme_selected_bg_color;
              background: transparent;
              animation: fade 0.1s linear;
            }

            @keyframes fade {
              0% {
                opacity: 0;
              }

              100% {
                opacity: 1;
              }
            }
          '';
      };
    };
}
