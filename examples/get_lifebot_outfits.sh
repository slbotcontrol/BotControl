#!/bin/bash
#
# To retrieve a list of a configured LifeBots bot's Outfits use the lifebot command
# with the get_outfits action. In this example we specify the bot name as Anya, an
# alias configured in ~/.botctrl with BOT_NAME_Anya="Anya Ordinary"
#
# In this example we use the jq JSON parser, if it is available, to filter the returned
# JSON, displaying only a list of the outfit names. If jq not available we use grep.

# Replace 'Anya' with your LifeBots bot name or an alias for the name you have configured
BOT_NAME="Anya"

have_jq=$(type -p jq)
if [ "${have_jq}" ]; then
  lifebot -a get_outfits -n "${BOT_NAME}" | jq -r '.outfits[].name'
else
  lifebot -a get_outfits -n "${BOT_NAME}" | grep name
fi
