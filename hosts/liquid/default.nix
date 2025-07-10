{ specialArgs, lib, ... }:
{
  imports = [
    ./prefs.nix
    ./homebrew.nix
    ./beekeeper.nix
    specialArgs.sops-nix.darwinModules.sops
    specialArgs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.yuri = import ../../users/yuri/liquid.nix;
      home-manager.sharedModules = [
        specialArgs.sops-nix.homeManagerModule
      ];
    }
  ];
  system = {
    configurationRevision = specialArgs.self.rev or specialArgs.self.dirtyRev or null;
    stateVersion = 6;
  };
  nix = {
    enable = true;
    settings.experimental-features = "nix-command flakes";
    optimise.automatic = true;
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "google-chrome"
        "raycast"
        "shottr"
        "the-unarchiver"
      ];
  };
  users.users.yuri = {
    name = "yuri";
    home = "/Users/yuri";
  };
}
