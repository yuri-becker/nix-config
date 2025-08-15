{ ... }:
{
  homebrew.casks = [ "notunes" ];
  launchd.user.agents.notunes = {
    serviceConfig = {
      Label = "noTunes";
      Program = "/System/Volumes/Data/Applications/noTunes.app";
    };
  };
}
