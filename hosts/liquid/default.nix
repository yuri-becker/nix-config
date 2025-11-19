{ specialArgs, lib, ... }:
{
  imports = [
    ../../mixins/nix-options.nix
    ./prefs.nix
    ./homebrew.nix
    ./notunes.nix
    ./beekeeper.nix
    specialArgs.sops-nix.darwinModules.sops
    specialArgs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.yuri.imports = [ ../../users/yuri/liquid.nix ];
      home-manager.sharedModules = [
        specialArgs.sops-nix.homeManagerModule
      ];
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
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "raycast"
        "shottr"
        "the-unarchiver"
      ];
    config.permittedInsecurePackages = [
      "electron-36.9.5"
    ];
  };
  users.users.yuri = {
    name = "yuri";
    home = "/Users/yuri";
  };
}
