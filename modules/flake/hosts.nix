{
  inputs,
  lib,
  config,
  ...
}:
let
  prefix = "hosts/";
  suffix = "-iso";
  collectHostsModules = modules: lib.filterAttrs (name: _: lib.hasPrefix prefix name) modules;
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
          specialArgs = {
            hostConfig = module // {
              name = lib.removeSuffix suffix (lib.removePrefix prefix name);
              isInstall = !(lib.hasSuffix suffix name);
            };
          };
        in
        {
          name = lib.removeSuffix suffix (lib.removePrefix prefix name);
          value = inputs.nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            modules = module.imports ++ [
              inputs.home-manager.nixosModules.home-manager
              { home-manager.extraSpecialArgs = specialArgs; }
            ];
          };
        }
      ))
    ];
  };
}
