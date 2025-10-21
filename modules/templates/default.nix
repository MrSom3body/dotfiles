{
  flake = {
    templates = {
      default = {
        path = ./_default;
        description = "my default dev template";
      };

      python-uv = {
        path = ./_python-uv;
        description = "a python uv dev template";
      };
    };
  };
}
