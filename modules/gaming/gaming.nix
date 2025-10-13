{
  flake.modules = {

    homeManager.gaming =
      { pkgs, ... }:
      {
        home.packages = builtins.attrValues {
          inherit (pkgs)
            goverlay
            heroic
            mindustry-wayland
            modrinth-app
            r2modman
            ;
        };

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
