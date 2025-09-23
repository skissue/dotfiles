{
  services.logind.settings.Login = {
    HandlePowerKeyLongPress = "poweroff";
    # Handle this in userspace when it matters.
    HandleLidSwitch = "ignore";
  };
}
