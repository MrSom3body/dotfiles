{
  flake.modules.homeManager.office = {
    programs.obsidian = {
      enable = true;
      # vaults = {
      #   Privat = {
      #     enable = true;
      #     target = "Documents/Notes/Privat";
      #   };
      #   Schule = {
      #     enable = true;
      #     target = "Documents/Notes/Schule";
      #   };
      # };

      # defaultSettings = {
      #   app = {
      #     vimMode = true;
      #     spellcheck = false;
      #     attachmentFolderPath = "./attachments";
      #   };

      #   extraFiles = {
      #     "plugins/obsidian-linter/data.json".source = ./linter.json;
      #   };

      #   corePlugins = [
      #     "backlink"
      #     "bookmarks"
      #     "canvas"
      #     "command-palette"
      #     "daily-notes"
      #     "editor-status"
      #     "file-explorer"
      #     "file-recovery"
      #     # "footnotes"
      #     "global-search"
      #     "graph"
      #     "note-composer"
      #     "outgoing-link"
      #     "outline"
      #     "page-preview"
      #     "slash-command"
      #     "switcher"
      #     "tag-pane"
      #     "templates"
      #     "word-count"
      #   ];

      #   # communityPlugins = [
      #   #   "cm-editor-syntax-highlight-obsidian"
      #   #   "code-block-copy"
      #   #   "folder-notes"
      #   #   "obsidian-auto-link-title"
      #   #   "obsidian-completr"
      #   #   "obsidian-discordrpc"
      #   #   "obsidian-excalidraw-plugin"
      #   #   "obsidian-excel-to-markdown-table"
      #   #   "obsidian-languagetool-plugin"
      #   #   "obsidian-latex-suite"
      #   #   "obsidian-linter"
      #   #   "obsidian-regex-replace"
      #   #   "obsidian-smart-typography"
      #   #   "update-time-on-edit"
      #   #   # "obsidian-desmos"
      #   #   # "obsidian-functionplot"
      #   # ];
      # };
    };
  };
}
