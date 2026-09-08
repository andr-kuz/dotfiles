{ ... }: {
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # cache mirror
    ];
    # Optional: if the mirror requires specific public keys, but Tsinghua mirrors the official cache, 
    # so the default cache.nixos.org-1 key is sufficient.
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
}
