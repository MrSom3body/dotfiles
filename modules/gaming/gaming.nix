{
  flake.modules = {

    homeManager.gaming =
      { pkgs, ... }:
      {
        home.packages =
          (with pkgs; [
            goverlay
            heroic
            mindustry-wayland
            r2modman
          ])
          ++ [
            # TODO move back to stable after https://github.com/NixOS/nixpkgs/issues/460140 gets resolved
            pkgs.stable.modrinth-app
          ];

        # TODO remove when modrinth works normally again on wayland
        xdg.desktopEntries = {
          "Modrinth App" = {
            categories = [
              "Game"
              "ActionGame"
              "AdventureGame"
              "Simulation"
            ];
            exec = ''sh -c "GDK_BACKEND=x11 ModrinthApp"'';
            icon = "ModrinthApp";
            name = "Modrinth App";
            terminal = false;
            type = "Application";
            mimeType = [
              "application/x-modrinth-modpack+zip"
              "x-scheme-handler/modrinth"
            ];
            comment = "Modrinth's game launcher";
            startupNotify = true;
          };
        };
      };
  };
}
