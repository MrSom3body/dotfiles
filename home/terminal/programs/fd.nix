{...}: {
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [".git/"];
  };
}
