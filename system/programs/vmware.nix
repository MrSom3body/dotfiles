{pkgs-stable, ...}: {
  virtualisation.vmware.host = {
    enable = true;
    package = pkgs-stable.vmware-workstation;
    extraConfig = ''
      # Allow unsupported device's OpenGL and Vulkan acceleration for guest vGPU
      mks.gl.allowUnsupportedDrivers = "TRUE"
      mks.vk.allowUnsupportedDevices = "TRUE"
    '';
  };
}
