# rename this file to `proxy_config.nix` and put the bridge string in the variable
# The plugin client will be detected automatically
# Do not forget to `sudo nixos-rebuild switch` after
{
  bridges = [
    "obfs4 <IP>:<PORT> ..."
    "..."
  ];
}
