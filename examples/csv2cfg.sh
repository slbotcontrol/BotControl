#!/bin/bash
#
# Generate the discord.cfg entries to append for the Discord Relay Online Tracker addon
#
# Auto creates a Nickname using the avatar display name
#
# Current method using an exported CSV of group members
GM="Your-Group-Members-Export.csv"
# Previous method with Display Names and Names generated from UUIDs 
DN="Display_Names"
RN="Names"
UL="UUIDs"
# Discord Relay Config without Online Tracker UUIDs appended
CF="discord_online.cfg"
# Output folder
OD="Config"
# Output file
OF="${OD}/${CF}"

info() { printf "%b[info] %b %s\n" '\e[0;32m\033[1m' '\e[0m' "$*" >&2; }
warn() { printf "%b[warn] %b %s\n" '\e[0;33m\033[1m' '\e[0m' "$*" >&2; }
erro() { printf "%b[error]%b %s\n" '\e[0;31m\033[1m' '\e[0m' "$*" >&2; }

is_valid_csv() {
  local input_string="$1"
  # Check if the string contains a comma
  if [[ "$input_string" == *","* ]]; then
    # Check if the string contains a comma at the beginning or end
    if [[ "$input_string" == ","* ]] || [[ "$input_string" == *"," ]]; then
      return 1
    else
      return 0
    fi
  else
    return 1
  fi
}

is_valid_uuid() {
  local uuid="$1"
  if [[ $uuid =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
    return 0 # Valid
  else
    return 1 # Invalid
  fi
}

[ -d "${OD}" ] || mkdir -p "${OD}"

# Output the basic Discord Relay config for this addon if it is here
if [ -f "${CF}" ]; then
  cp "${CF}" "${OF}"
else
  warn "Discord Relay configuration not found. Append the output to an appropriate config."
fi

# Check if we have a group membership CSV and if so, use it
if [ -f "${GM}" ]; then
  # Entries are of the form:
  # UUID,Display Name (account.name),last online,land contribution
  info "Using exported group membership CSV"
  cat ${GM} | while read line
  do
    is_valid_csv "${line}" || continue
    uuid=$(echo "${line}" | awk -F ',' '{ print $1 }')
    is_valid_uuid "${uuid}" || continue
    # TODO: check if this avatar is a scripted agent
    name=$(echo "${line}" | awk -F ',' '{ print $2 }')
    if [ "${name}" ]; then
      echo "{key} = ${uuid}" >> "${OF}"
      echo "Nickname:${name} = ${uuid}" >> "${OF}"
    else
      echo "{key} = ${uuid}" >> "${OF}"
    fi
  done
else
  # If not then see if we have the generated lists of UUIDs, display names, and names
  warn "Cannot locate group membership CSV ${GM}"
  [ -f "${UL}" ] || {
    erro "Cannot locate list of UUIDs ${UL}"
    exit 1
  }
  [ -f "${DN}" ] || {
    erro "Cannot locate list of display names ${DN}"
    exit 1
  }
  [ -f "${RN}" ] || {
    erro "Cannot locate list of names ${RN}"
    exit 1
  }
  info "Using previously generated lists of UUIDs, display names, and names"

  cat ${UL} | while read uuid
  do
    d_name=$(grep "${uuid}" ${DN} | awk -F ',' '{ print $1 }')
    r_name=$(grep "${uuid}" ${RN} | awk -F ',' '{ print $1 }' | sed -e "s/ Resident$//")
    if [ "${d_name}" == "${r_name}" ]; then
      f_name="${d_name}"
    else
      f_name="${d_name} (${r_name})"
    fi
    echo "{key} = ${uuid}" >> "${OF}"
    echo "Nickname:${f_name} = ${uuid}" >> "${OF}"
  done
fi

info "Discord Relay Online Tracker configuration generated:"
info "    ${OF}"
