#!/bin/bash
#
# To change the outfit of a configured Corrade bot use the corrade command
# with the wear_outfit action. In this example we specify the bot name as Easy, an
# alias configured in ~/.botctrl with BOT_NAME_Easy="Easy Islay"
#
# Note, we can use the -n Name command line arguments to specify the bot name because
# we are using the corrade command. The same command could be run using the botctrl
# command but it would be "botctrl -a wear_outfit -c Easy ...", using the -c Name instead.
#
# In this example we use the jq JSON parser, if it is available, to filter the returned
# JSON and capture the returned success value in a variable. In this way we can decide
# whether to proceed with the next bot action based on the success or failure of the command.
#
# NOTE: all Corrade API requests return this 'success' JSON field allowing any Corrade
# command to do something similar - check the result and act accordingly.

# Replace 'Easy' with your Corrade bot name or an alias for the name you have configured
BOT_NAME="Easy"
# Replace this outfit name with one from your Corrade bot retrieved with the
# get_corrade_outfits.sh example
OUTFIT_NAME='** Legacy Basic Pretty in Pink **'

debug=
[ "$1" == "-v" ] && debug=1

if [ "${debug}" ]; then
  corrade -a wear_outfit -n "${BOT_NAME}" -O "${OUTFIT_NAME}" -v
else
  have_jq=$(type -p jq)
  if [ "${have_jq}" ]; then
    retval=$(corrade -a wear_outfit -n "${BOT_NAME}" -O "${OUTFIT_NAME}" | jq -r '.success')
    if [ "${retval}" == "True" ]; then
      echo "Outfit change succeeded! We can go out to the club now."
    else
      echo "Outfit change failed :( Run me again with the -v argument to see what's wrong."
    fi
  else
    corrade -a wear_outfit -n "${BOT_NAME}" -O "${OUTFIT_NAME}"
  fi
fi
