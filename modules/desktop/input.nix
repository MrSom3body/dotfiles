{
  flake.modules.homeManager.desktop = {
    # fixes GTK applications not picking up dead keys
    home.sessionVariables."GTK_IM_MODULE" = "simple";
  };
}
