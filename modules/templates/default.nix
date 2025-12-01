{
  flake = {
    templates = {
      default = {
        path = ./_default;
        description = "my default dev template";
      };

      go = {
        path = ./_go;
        description = "a go dev template";
      };

      python-uv = {
        path = ./_python-uv;
        description = "a python uv dev template";
      };
    };
  };
}
