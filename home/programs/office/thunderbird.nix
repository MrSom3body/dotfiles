{
  programs.thunderbird = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        search = {
          default = "ddg";
          privateDefault = "ddg";
        };
      };
    };
  };
}
