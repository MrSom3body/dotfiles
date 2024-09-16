{pkgs, ...}: {
  users.users.karun = {
    isNormalUser = true;
    description = "Karun Sandhu";
    shell = pkgs.fish;
    initialPassword = "password";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
    ];
  };
}
