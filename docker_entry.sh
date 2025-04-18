#!/bin/sh

${STEAMCMDDIR}/steamcmd.sh +force_install_dir ${GAMEDIR} +login anonymous \
     +app_update ${GAMEID} validate +quit

cd "${GAMEDIR}"

# Ensure config directory exists
mkdir -p "${CONFIGDIR}"

# Edit the config file
set_config_value() {
    local file="$1"
    local key="$2"
    local value="$3"

    if grep -q "^${key}:" "$file" 2>/dev/null; then
        sed -i "s|^${key}:.*|${key}: ${value}|" "$file"
    else
        echo "${key}: ${value}" >> "$file"
    fi
}

echo "Editing config file \"${CONFIGDIR}/config_gameplay.txt\""

set_config_value "${CONFIGDIR}/config_gameplay.txt" "server_name" "${SERVERNAME}"
set_config_value "${CONFIGDIR}/config_gameplay.txt" "minimum_players" "${MINPLAYERS}"

cat "${CONFIGDIR}/config_gameplay.txt"

exec ./LocalAdmin ${SERVERPORT} --acceptEULA --useDefault
