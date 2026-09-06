#!/usr/bin/env bash

set -ouex pipefail

echo "▶ Instalando SteamCMD en la imagen base (Ryoku OS)..."

# Dependencias 32-bit para steamcmd normalmente necesarias
dnf install -y glibc.i686 libstdc++.i686 tar gzip curl

mkdir -p /usr/local/share/steamcmd
mkdir -p /usr/local/bin

curl -sSL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -xz -C /usr/local/share/steamcmd 2>/dev/null || true

cat > /usr/local/bin/steamcmd << 'STEAMCMDEOF'
#!/bin/bash
exec "/usr/local/share/steamcmd/steamcmd.sh" "$@"
STEAMCMDEOF

chmod +x /usr/local/bin/steamcmd
echo "✓ SteamCMD instalado en la imagen."
