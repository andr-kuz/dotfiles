{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/discord.enable;
in
lib.mkIf trigger {
  services.zapret = {

    params = [
      # БЛОК 1: Голос в Discord (UDP)
      "--filter-udp=19294-19344,50000-50100"
      "--filter-l7=discord,stun"
      "--dpi-desync=fake"
      "--dpi-desync-fake-discord=0x00000000"
      "--dpi-desync-fake-stun=0x00000000"
      "--dpi-desync-repeats=6"

      # БЛОК 2: Альтернативные порты картинок Discord (TCP Cloudflare)
      "--new"
      "--filter-tcp=2053,2083,2087,2096,8443"
      "--dpi-desync=fake,multidisorder"
      "--dpi-desync-fooling=badseq"
      "--dpi-desync-fake-tls=0x00000000"

      # БЛОК 3: Основной трафик (YouTube + Discord API) на 80/443
      "--new"
      "--filter-tcp=80,443"
      "--ip-id=zero"
      "--dpi-desync=fake,multidisorder"
      "--dpi-desync-autottl=2"
      "--dpi-desync-fooling=badseq"
      "--dpi-desync-split-pos=midsld"
      "--dpi-desync-fake-tls=0x00000000"
    ];
    whitelist = [
      "discord.com"
      "discord.gg"
      "discord.media"
      "discordapp.com"
      "discordapp.net"
      "discordstatus.com"
      "dis.gd"
      "discordcdn.com"
      "discord.co"
      "discord.app"
      "discord-attachments-uploads-prd.storage.googleapis.com"
      "discord.status"
      "discordstatus.com"
      "discord-activities.com"
      "discordactivities.com"
      "discordsays.com"
      "discordsez.com"
      "discord.design"
      "discord.dev"
      "discord.gift"
      "discord.gifts"
      "discord.new"
      "discordmerch.com"
      "discordpartygames.com"
    ];
  };
}
