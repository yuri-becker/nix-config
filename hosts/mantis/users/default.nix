{ config, specialArgs, ... }:
let
  sopsFile = ./secrets.yaml;
in
{
  imports = [
    specialArgs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.yuri = import ../../../users/yuri/mantis.nix;
      home-manager.sharedModules = [
        specialArgs.sops-nix.homeManagerModule
      ];
    }
  ];

  sops.secrets."passwords/yuri" = {
    sopsFile = sopsFile;
    neededForUsers = true;
  };

  users.users.yuri = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.sops.secrets."passwords/yuri".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9o2ZABpuAuvMpfUnGQhmmHBZkn9BZAkw+FJ1EZigdJ" # liquid
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPU5cxsWMG+MW1abpp2xk0sJUip/kxCTnmi6LoEyBMQ4" # solidus
    ];
  };
}
