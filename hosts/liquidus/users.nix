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
          imports = [ ../../users/yuri ];
          localhost.enable = true;
          localhost.personal.enable = true;
          localhost.gnome.enable = true;
          localhost.threed-printing.enable = true;
          localhost.moonlight.enable = true;
        }
      );
      home-manager.sharedModules = [ specialArgs.sops-nix.homeManagerModule ];
      home-manager.extraSpecialArgs = {
        hostname = "liquidus";
      }
      // specialArgs;
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
