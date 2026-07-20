{
  lib,
  config,
  inputs,
  ...
}:
let
  mkNixos =
    system: cls: name:
    lib.nixosSystem {
      inherit system;
      modules = [
        config.flake.modules.nixos.${cls}
        config.flake.modules.nixos."hosts/${name}"
        {
          home-manager.users.karun.imports = [
            config.flake.modules.homeManager.homeManager
            (config.flake.modules.homeManager."hosts/${name}" or { })
          ];

          networking.hostName = lib.mkDefault name;
          nixpkgs.hostPlatform = lib.mkDefault system;
          # This value determines the NixOS release from which the default
          # settings for stateful data, like file locations and database versions
          # on your system were taken. It‘s perfectly fine and recommended to leave
          # this value at the release version of the first install of this system.
          # Before changing this value read the documentation for this option
          # (e.g. man configuration.nix or on https://search.nixos.org/options?&show=system.stateVersion&from=0&size=50&sort=relevance&type=packages&query=stateVersion).
          system.stateVersion = "24.05";
        }
      ];
    };

in
{
  flake.lib = {
    isInstall = config: !(lib.hasAttrByPath [ "isoImage" ] config);

    getRunningServices =
      flake:
      let
        allVirtualHosts = lib.concatMapAttrs (
          _name: conf: conf.config.services.caddy.virtualHosts or { }
        ) flake.nixosConfigurations;

        hostSpecificServices = lib.flatten (
          lib.mapAttrsToList (
            name: service:
            if service.hostSpecific && service.checkEnabled != null then
              lib.filter (x: x != null) (
                lib.mapAttrsToList (
                  hostName: hostConf:
                  if service.checkEnabled hostConf.config then
                    let
                      evalDomain =
                        if builtins.isString service.domain then
                          service.domain
                        else
                          (if service.domain != null then service.domain hostName else null);
                      evalUrl =
                        if builtins.isString service.url then
                          service.url
                        else
                          (if service.url != null then service.url hostName else null);
                    in
                    if
                      service.external
                      || (evalDomain != null && (allVirtualHosts ? "${evalDomain}"))
                      || (evalDomain == null)
                    then
                      service
                      // {
                        name = "${name}-${hostName}";
                        title = "${service.title} (${hostName})";
                        domain = evalDomain;
                        url = evalUrl;
                      }
                    else
                      null
                  else
                    null
                ) flake.nixosConfigurations
              )
            else
              [ ]
          ) flake.meta.services
        );

        globalServices = lib.mapAttrsToList (name: service: service // { inherit name; }) (
          lib.filterAttrs (
            _name: service:
            !service.hostSpecific
            && (service.domain != null)
            && (service.external || (allVirtualHosts ? "${service.domain}"))
          ) flake.meta.services
        );
      in
      builtins.listToAttrs (
        map (s: {
          inherit (s) name;
          value = s;
        }) (globalServices ++ hostSpecificServices)
      );

    mkSystems = {
      linux = mkNixos "x86_64-linux" "nixos";
      linux-arm = mkNixos "aarch64-linux" "nixos";
      wsl = mkNixos "x86_64-linux" "wsl";
    };

    loadNixosAndHmModules =
      config: modules:
      assert builtins.isAttrs config;
      assert builtins.isList modules;
      let
        checks = map (
          module:
          lib.throwIf (
            !(builtins.hasAttr module config.flake.modules.nixos)
            && !(builtins.hasAttr module config.flake.modules.homeManager)
          ) "loadNixosAndHmModules: module '${module}' has neither a NixOS nor a Home Manager module" true
        ) modules;
      in
      builtins.deepSeq checks (
        (map (module: config.flake.modules.nixos.${module} or { }) modules)
        ++ [
          {
            imports = [ inputs.home-manager.nixosModules.home-manager ];

            home-manager.users.karun.imports = map (
              module: config.flake.modules.homeManager.${module} or { }
            ) modules;
          }
        ]
      );
  };
}
