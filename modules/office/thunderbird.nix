{
  flake.modules.homeManager.office = {
    programs.thunderbird = {
      enable = true;
      profiles = {
        default = {
          isDefault = true;
          search = {
            force = true;
            default = "ddg";
            privateDefault = "ddg";
          };
        };
      };
    };
  };
}
