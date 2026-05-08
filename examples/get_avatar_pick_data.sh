#!/bin/bash
#
# REQUIRED: jq
#
# To view a pick description of an avatar using a configured Corrade bot,
# use the corrade command with the avatar_picks action to retrieve the avatar's
# picks then use the corrade command with the pickdata action to retrieve the
# pick description. In this example we specify the bot name as Easy, an alias
# configured in ~/.botctrl with BOT_NAME_Easy="Easy Islay"
#
# Note, we can use the -n Name command line arguments to specify the bot name because
# we are using the corrade command. The same command could be run using the botctrl
# command but it would be "botctrl -c Easy ...", using the -c Name instead.
#
# In this example we use the jq JSON parser, if it is available, to filter the returned
# JSON and capture the returned pick UUID value in a variable. At first we try to get
# the avatar's second pick Name and UUID. If that fails we try to get the first pick.

# Replace 'Easy' with your Corrade bot name or an alias for the name you have configured
BOT_NAME="Easy"
# Replace 'Missy Restless' with the name of the avatar whose pick you want to see
AVATAR_NAME='Missy Restless'

pick_uuid=
have_jq=$(type -p jq)
if [ "${have_jq}" ]; then
  # Retrieve the second pick name and uuid
  pick_name=$(corrade -a avatar_picks -n "${BOT_NAME}" -A "${AVATAR_NAME}" | jq -r '.data[3]')
  pick_uuid=$(corrade -a avatar_picks -n "${BOT_NAME}" -A "${AVATAR_NAME}" | jq -r '.data[2]')
  if [ "${pick_uuid}" ]; then
    printf "\nAvatar ${AVATAR_NAME}'s pick: \"${pick_name}\"\n\n"
    # Retrieve the pick description
    corrade -a pickdata -n "${BOT_NAME}" -A "${AVATAR_NAME}" -u "${pick_uuid}" | jq -r '.data[1]'
  else
    # Retrieve the first pick name and uuid
    pick_name=$(corrade -a avatar_picks -n "${BOT_NAME}" -A "${AVATAR_NAME}" | jq -r '.data[1]')
    pick_uuid=$(corrade -a avatar_picks -n "${BOT_NAME}" -A "${AVATAR_NAME}" | jq -r '.data[0]')
    if [ "${pick_uuid}" ]; then
      printf "\nAvatar ${AVATAR_NAME}'s pick: \"${pick_name}\"\n\n"
      # Retrieve the pick description
      corrade -a pickdata -n "${BOT_NAME}" -A "${AVATAR_NAME}" -u "${pick_uuid}" | jq -r '.data[1]'
    else
      echo "Could not locate a pick for avatar ${AVATAR_NAME}"
    fi
  fi
else
  echo "ERROR: jq not found"
fi
