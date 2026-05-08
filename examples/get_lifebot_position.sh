#!/bin/bash
#
# To retrieve the position of a configured LifeBots bot use the lifebot command
# with the bot_location action. In this example we specify the bot name as Anya,
# an alias configured in ~/.botctrl with BOT_NAME_Anya="Anya Ordinary"
#
# Replace 'Anya' with your LifeBots bot name or an alias for the name you have configured
BOT_NAME="Anya"

debug=
[ "$1" == "-v" ] && debug=1

if [ "${debug}" ]; then
  lifebot -a bot_location -n "${BOT_NAME}" -v
else
  have_jq=$(type -p jq)
  if [ "${have_jq}" ]; then
    lifebot -a bot_location -n "${BOT_NAME}" | jq -r '"\(.region), \(.x), \(.y), \(.z)"'
  else
    lifebot -a bot_location -n "${BOT_NAME}"
  fi
fi
