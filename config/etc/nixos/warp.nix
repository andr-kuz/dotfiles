{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/warp.enable;
in
lib.mkIf trigger {
  services.zapret = {
    params = [
      "--ipset-exclude-ip=162.159.192.0/24"
    ];
    whitelist = [
      "signin.aws.amazon.com"
      "cloudfront.net"
      "s3.amazonaws.com"
      "awsstatic.com"
      "console.aws.a2z.com"
      "amazonaws.com"
      "awsapps.com"
      "sso.amazonaws.com"
      "cloudfront.net"
      "argotunnel.com"
      "cfargotunnel.com"
      "cfl.re"
      "cloudflare-dns.com"
      "cloudflare-ech.com"
      "cloudflare-esni.com"
      "cloudflare-gateway.com"
      "cloudflare-quic.com"
      "cloudflare.com"
      "cloudflare.net"
      "cloudflare.tv"
      "cloudflareaccess.com"
      "cloudflareapps.com"
      "cloudflarebolt.com"
      "cloudflareclient.com"
      "cloudflareinsights.com"
      "cloudflareok.com"
      "cloudflarepartners.com"
      "cloudflareportal.com"
      "cloudflarepreview.com"
      "cloudflareresolve.com"
      "cloudflaressl.com"
      "cloudflarestatus.com"
      "cloudflarestorage.com"
      "cloudflarestream.com"
      "cloudflaretest.com"
      "cloudflarewarp.com"
      "every1dns.net"
      "isbgpsafeyet.com"
      "one.one.one.one"
      "one.one.one"
      "pacloudflare.com"
      "pages.dev"
      "trycloudflare.com"
      "videodelivery.net"
      "warp.plus"
      "workers.dev"
    ];
    udpSupport = true;
    udpPorts = [ "443" "2408" ];
  };
  services.cloudflare-warp.enable = true;

  # Install the WARP command line client
  environment.systemPackages = with pkgs; [
    cloudflare-warp
  ];
}
