{
  services.logind = {
    powerKeyLongPress = "poweroff";
    # Handle this in userspace when it matters.
    lidSwitch = "ignore";
  };
}
