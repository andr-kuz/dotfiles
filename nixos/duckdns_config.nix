let
  env = builtins.fromTOML (builtins.readFile ./env.toml);
in
{
  duckDnsDomain = env.DUCK_DNS_DOMAIN;
  duckDnsToken = env.DUCK_DNS_TOKEN;
}
