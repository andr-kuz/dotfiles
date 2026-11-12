final: prev: {
  xray = prev.stdenv.mkDerivation rec {
    pname = "xray";
    version = "26.11.9";

    src = prev.fetchurl {
      url = "https://github.com/XTLS/Xray-core/releases/download/v${version}/Xray-linux-64.zip";
      hash = "sha256-tlH34dmWbuLBse4b+LUscncYJNMGXc6Wu8i8wZ7ZX4I=";
    };

    nativeBuildInputs = [ prev.unzip ];
    sourceRoot = ".";

    installPhase = ''
      install -Dm755 xray $out/bin/xray
      install -Dm644 geoip.dat $out/share/xray/geoip.dat
      install -Dm644 geosite.dat $out/share/xray/geosite.dat
    '';
  };
}
