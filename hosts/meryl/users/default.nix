{ specialArgs, ... }:
{
  imports = [
    specialArgs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.yuri = import ../../../users/yuri/meryl.nix;
      home-manager.sharedModules = [
        specialArgs.sops-nix.homeManagerModule
      ];
      home-manager.extraSpecialArgs = {
        hostname = "meryl";
        wakatime-ls = specialArgs.wakatime-ls;
      };
    }
  ];

  users.users.yuri = {
    isNormalUser = true;
    description = "Yuri";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
