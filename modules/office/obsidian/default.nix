{
  flake.modules.homeManager.office =
    { config, ... }:
    {
      programs.obsidian = {
        enable = true;
        vaults = {
          Privat = {
            enable = true;
            target = "Documents/Notes/Privat";
          };
          Schule = {
            enable = true;
            target = "Documents/Notes/Schule";
          };
        };

        defaultSettings = {
          app = {
            pdfExportSettings = {
              includeName = true;
              pageSize = "A4";
              landscape = false;
              margin = 0;
              downscalePercent = 100;
            };
            vimMode = true;
            spellcheck = false;
            attachmentFolderPath = "./attachments";
            alwaysUpdateLinks = true;
            newFileLocation = "current";
            showLineNumber = true;
          };

          cssSnippets =
            let
              colors = config.lib.stylix.colors.withHashtag;
            in
            [
              {
                name = "Colored Headings";
                text = /* css */ ''
                  :root {
                    --h1-color: ${colors.base08};
                    --h2-color: ${colors.base09};
                    --h3-color: ${colors.base0A};
                    --h4-color: ${colors.base0B};
                    --h5-color: ${colors.base0C};
                    --h6-color: ${colors.base0D};
                  }
                '';
              }
            ];

          extraFiles = {
            "plugins/obsidian-linter/data.json".source = ./linter.json;
          };

          corePlugins = [
            "backlink"
            "bookmarks"
            "canvas"
            "command-palette"
            "daily-notes"
            "editor-status"
            "file-explorer"
            "file-recovery"
            "footnotes"
            "global-search"
            "graph"
            "note-composer"
            "outgoing-link"
            "outline"
            "page-preview"
            "slash-command"
            "switcher"
            "tag-pane"
            "templates"
            "word-count"
          ];

          # communityPlugins = [
          #   "cm-editor-syntax-highlight-obsidian"
          #   "code-block-copy"
          #   "folder-notes"
          #   "obsidian-auto-link-title"
          #   "obsidian-completr"
          #   "obsidian-discordrpc"
          #   "obsidian-excalidraw-plugin"
          #   "obsidian-excel-to-markdown-table"
          #   "obsidian-languagetool-plugin"
          #   "obsidian-latex-suite"
          #   "obsidian-linter"
          #   "obsidian-regex-replace"
          #   "obsidian-smart-typography"
          #   "update-time-on-edit"
          #   # "obsidian-desmos"
          #   # "obsidian-functionplot"
          # ];
        };
      };
    };
}
