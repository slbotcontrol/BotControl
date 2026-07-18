#!/bin/bash
#
# To retrieve a list of a configured Corrade bot's Outfits use the corrade command
# with the get_outfits action. In this example we specify the bot name as Easy, an
# alias configured in ~/.botctrl with BOT_NAME_Easy="Easy Islay"
#
# Note, we can use the -n Name command line arguments to specify the bot name because
# we are using the corrade command. The same command could be run using the botctrl
# command but it would be "botctrl -a get_outfits -c Easy", using the -c Name instead.
#
# In this example we use the jq JSON parser, if it is available, to filter the returned
# JSON, displaying only a list of the outfit names. If jq not available we use grep.

# Replace 'Easy' with your Corrade bot name or an alias for the name you have configured
DEF_BOT_NAME="Easy"
BOT_NAME=

usage() {
  printf "\nUsage: get_corrade_outfits [-n NAME]"
  printf "\nWhere:"
  printf "\n\t-n NAME specifies a Corrade bot name [Default: ${DEF_BOT_NAME}]\n"
  exit 1
}

while getopts ":n:u" flag; do
  case $flag in
    n)
      BOT_NAME="$OPTARG"
      ;;
    u)
      usage
      ;;
    \?)
      echo "Invalid option: $flag"
      usage
      ;;
  esac
done
shift $(( OPTIND - 1 ))

[ "${BOT_NAME}" ] || BOT_NAME="${DEF_BOT_NAME}"

have_jq=$(type -p jq)
if [ "${have_jq}" ]; then
  corrade -a get_outfits -n "${BOT_NAME}" | jq -r '.outfits[].name'
else
  corrade -a get_outfits -n "${BOT_NAME}" | grep name
fi
