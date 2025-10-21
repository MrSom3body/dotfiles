{
  inputs,
  lib,
  config,
  ...
}:
let
  hostPrefix = "hosts/";
  isoPrefix = "iso/";

  removeAnyPrefix =
    name:
    if lib.hasPrefix hostPrefix name then
      lib.removePrefix hostPrefix name
    else if lib.hasPrefix isoPrefix name then
      lib.removePrefix isoPrefix name
    else
      name;

  isConfiguration = name: lib.hasPrefix hostPrefix name || lib.hasPrefix isoPrefix name;

  collectHostsModules = modules: lib.filterAttrs (name: _: isConfiguration name) modules;
in
{
  flake = {
    lib = {
      loadNixosAndHmModuleForUser =
        config: modules: username:
        assert builtins.isAttrs config;
        assert builtins.isList modules;
        assert builtins.isString username;
        {
          imports = (builtins.map (module: config.flake.modules.nixos.${module} or { }) modules) ++ [
            {
              imports = [ inputs.home-manager.nixosModules.home-manager ];

              home-manager.users.${username}.imports = builtins.map (
                module: config.flake.modules.homeManager.${module} or { }
              ) modules;
            }
          ];
        };
    };

    nixosConfigurations = lib.pipe (collectHostsModules config.flake.modules.nixos) [
      (lib.mapAttrs' (
        name: module:
        let
          cleanedName = removeAnyPrefix name;
          isInstall = lib.hasPrefix hostPrefix name;
          specialArgs = {
            hostConfig = module // {
              name = cleanedName;
              inherit isInstall;
            };
          };
        in
        {
          name = cleanedName;
          value = inputs.nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            modules =
              module.imports
              ++ [
                inputs.home-manager.nixosModules.home-manager
                { home-manager.extraSpecialArgs = specialArgs; }
              ]
              ++ lib.optional (!isInstall) config.flake.modules.nixos.iso;
          };
        }
      ))
    ];
  };
}
