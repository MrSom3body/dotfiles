{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.spicetify-nix.homeManagerModules.default];
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      betterGenres
      # keyboardShortcuts
      volumePercentage
    ];
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
      ncsVisualizer
    ];
    theme = spicePkgs.themes.comfy;
    colorScheme = "custom";
    customColorScheme = {
      text = config.lib.stylix.colors.base05;
      subtext = config.lib.stylix.colors.base04;
      main = config.lib.stylix.colors.base00;
      main-elevated = config.lib.stylix.colors.base01;
      main-transition = config.lib.stylix.colors.base01;
      highlight = config.lib.stylix.colors.base02;
      highlight-elevated = config.lib.stylix.colors.base00;
      sidebar = config.lib.stylix.colors.base01;
      player = config.lib.stylix.colors.base01;
      card = config.lib.stylix.colors.base03;
      shadow = config.lib.stylix.colors.base04;
      selected-row = config.lib.stylix.colors.base02;
      button = config.lib.stylix.colors.base0C;
      button-active = config.lib.stylix.colors.base0D;
      button-disabled = config.lib.stylix.colors.base03;
      tab-active = config.lib.stylix.colors.base02;
      notification = config.lib.stylix.colors.base06;
      notification-error = config.lib.stylix.colors.base08;
      misc = config.lib.stylix.colors.base04;
      play-button = config.lib.stylix.colors.base06;
      play-button-active = config.lib.stylix.colors.base0F;
      progress-fg = config.lib.stylix.colors.base02;
      progress-bg = config.lib.stylix.colors.base01;
      heart = config.lib.stylix.colors.base09;
      pagelink-active = config.lib.stylix.colors.base05;
      radio-btn-active = config.lib.stylix.colors.base0E;
    };
  };
}
