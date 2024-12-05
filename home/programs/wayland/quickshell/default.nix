{
  inputs,
  pkgs,
  ...
}: {
  home = {
    packages = [
      inputs.quickshell.packages.${pkgs.system}.default
    ];

    file.".config/quickshell/.qmlls.ini".text =
      # ini
      ''
        [General]
        buildDir=${inputs.quickshell.packages.${pkgs.system}.default}/lib/qt-6/qml
        no-cmake-calls=true
      '';

    # sessionVariables = {
    #   QML2_IMPORT_PATH = "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml:${inputs.quickshell.packages.${pkgs.system}.default}/lib/qt-6/qml";
    # };
  };
}
