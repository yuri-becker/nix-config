{ specialArgs, ... }:
{
  imports = [
    specialArgs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.yuri = (
        { ... }:
        {
          imports = [ ../../../users/yuri ];
          localhost.enable = true;
          localhost.work.enable = true;
        }
      );
      home-manager.sharedModules = [ specialArgs.sops-nix.homeManagerModule ];
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
