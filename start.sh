#!/usr/bin/env bash
set -euo pipefail

STEAMCMDDIR="${STEAMCMDDIR:-/opt/steamcmd}"
SERVERDIR="${SERVERDIR:-/opt/dragonwilds}"
CONFIG_FILE="${SERVERDIR}/RSDragonwilds/Saved/Config/Linux/DedicatedServer.ini"
INSTALLED_FLAG="${SERVERDIR}/.installed"

mkdir -p \
  "${SERVERDIR}" \
  "${SERVERDIR}/RSDragonwilds/Saved/Config/Linux" \
  "${SERVERDIR}/RSDragonwilds/Saved/Savegames" \
  "${SERVERDIR}/RSDragonwilds/Saved/Logs"

if [ ! -f "${INSTALLED_FLAG}" ]; then
  echo "Installation initiale du serveur..."
  "${STEAMCMDDIR}/steamcmd.sh" \
    +force_install_dir "${SERVERDIR}" \
    +login anonymous \
    +app_update 4019830 validate \
    +quit

  touch "${INSTALLED_FLAG}"
else
  echo "Serveur deja installe, installation ignoree."
fi

if [ ! -f "${CONFIG_FILE}" ]; then
  cat > "${CONFIG_FILE}" <<EOF
[/Script/RSDragonwilds.RSDedicatedServerConfig]
OwnerID=${OWNER_ID}
ServerName=${SERVER_NAME}
DefaultWorldName=${WORLD_NAME}
AdminPassword=${ADMIN_PASSWORD}
WorldPassword=${WORLD_PASSWORD:-}
EOF
fi

echo "Demarrage du serveur..."
cd "${SERVERDIR}"
exec ./RSDragonwilds/Binaries/Linux/RSDragonwildsServer-Linux-Shipping -log