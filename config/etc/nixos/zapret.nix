{ lib, pkgs, ... }:
let
trigger = builtins.pathExists /var/tmp/zapret.enable;
in
lib.mkIf trigger {
  services.zapret = {
    enable = true;
    params = [
      "--filter-tcp=80"
      "--dpi-desync=fake,fakedsplit"
      "--dpi-desync-autottl=2"
      "--dpi-desync-fooling=md5sig"
      "--new"
      "--filter-tcp=443"
      "--dpi-desync=fake,multidisorder"
      "--dpi-desync-fooling=badseq"
      "--dpi-desync-split-pos=midsld"
      "--dpi-desync-fake-tls=0x00000000"
    ];
    whitelist = [
      "googleusercontent.com"
      "accounts.google.com"
      "googleadservices.com"
      "googlevideo.com"
      "gvt1.com"
      "jnn-pa.googleapis.com"
      "play.google.com"
      "wide-youtube.l.google.com"
      "youtu.be"
      "youtube-nocookie.com"
      "youtube-ui.l.google.com"
      "youtube.com"
      "youtube.googleapis.com"
      "youtubeembeddedplayer.googleapis.com"
      "youtubei.googleapis.com"
      "yt-video-upload.l.google.com"
      "yt.be"
      "ytimg.com"
      "ggpht.com"
    ];
  };

  services.dnscrypt-proxy = {
    enable = true;
    settings = {
    # Choose fast, non-logging, encrypted upstream providers
      server_names = [ "cloudflare" ];
      listen_addresses = [ "127.0.0.1:53" "[::1]:53" ];

      # Security features to prevent ISP leaks
      cache = true;
    };
  };

  # 3. Force NixOS to use the local DNS Proxy only
  networking = {
    # Set the local loopback interface as the single DNS pool
    nameservers = [ "127.0.0.1" "::1" ];

    # Block NetworkManager from inserting default ISP servers via DHCP
    networkmanager.dns = "none";
  };

  # 4. Completely disable competing DNS managers
  services.resolved.enable = false;
}
