{
  # Enable the OpenSSH daemon.
  # `sudo nft list ruleset` rules check
  services.openssh = {
    enable = true;
    # change default port
    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
    };
  };

  users.users.valtrois = {
    isNormalUser = true;
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTyRXVHdJ121Vkw6COUGLgReKQu9OF3wGvkHDGa/5NC"  # phone   -> desktop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII5PvUlyOZqPxR0phqym3ulIgr/eM7WgEXqGXLurC9Gy"  # laptop  -> desktop
    ];
  };
}
