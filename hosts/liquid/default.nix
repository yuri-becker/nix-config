{ specialArgs, ... }:
{
  imports = [
    ./prefs.nix
    ./homebrew.nix
    ./notunes.nix
    ./beekeeper.nix
    specialArgs.sops-nix.darwinModules.sops
    specialArgs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.yuri.imports = [
        ../../users/yuri
        {
          localhost.enable = true;
          localhost.personal.enable = true;
        }
      ];
      home-manager.sharedModules = [ specialArgs.sops-nix.homeManagerModule ];
      home-manager.extraSpecialArgs = {
        hostname = "liquid";
        wakatime-ls = specialArgs.wakatime-ls;
      };
    }
  ];
  system = {
    configurationRevision = specialArgs.self.rev or specialArgs.self.dirtyRev or null;
    stateVersion = 6;
  };
  nix = {
    enable = true;
    extraOptions = "extra-platforms = x86_64-darwin aarch64-darwin";
    linux-builder.enable = true;
  };
  users.users.yuri = {
    name = "yuri";
    home = "/Users/yuri";
  };
}
