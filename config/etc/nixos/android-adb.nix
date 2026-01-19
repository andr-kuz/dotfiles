{
  programs.adb.enable = true;
  users.users.valtrois.extraGroups = [ "adbusers" ];
  # use `adb devices` to run adb daemon after waydroid container and session start
}
