{
  flake = {
    templates = {
      default = {
        path = ./default;
        description = "my default dev template";
      };

      python-uv = {
        path = ./python-uv;
        description = "a python uv dev template";
      };
    };
  };
}
