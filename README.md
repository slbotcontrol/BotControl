# BotControl Second Life Bots Command Line Control

Install `BotControl`:

```bash
curl -fsSL https://raw.githubusercontent.com/slbotcontrol/BotControl/refs/heads/main/install | bash
```

`BotControl` is a command line management system for `LifeBots` and `Corrade` Second Life
scripted agents (bots). The `botctrl` command can be used to manage either `Lite` or `Full` bots
from `LifeBots` as well as `Corrade` bots configured with the built-in Corrade HTTP service enabled.

The `botctrl` command is installed as `/usr/local/bin/botctrl` and symbolic links are created
for the commands `/usr/local/bin/corrade` and `/usr/local/bin/lifebot`. When invoked as `corrade`
the command uses the Corrade API to control Corrade bots. When invoked as `lifebot` the command
uses the LifeBots API to control LifeBots bots. When invoked as `botctrl` the command can control
either Corrade or LifeBots bots, determining which API to use based on how the bot name was specified
on the command line: `botctrl -c "bot name" ...` indicates use the Corrade API to control a Corrade
bot while `botctrl -n "bot name" ...` indicates control of a LifeBots bot.

**[NOTE:]** Missy Restless and the Truth &amp; Beauty Lab are not affiliated with
`Corrade` or `LifeBots` other than contributing `LifeBots` Knowledge Base articles.
This repository provides 3rd party tools for `Corrade` and `LifeBots` and is not
the official product of either. The official `LifeBots` site can be found at
[https://lifebots.cloud](https://lifebots.cloud) and `Corrade` at
[https://grimore.org/secondlife/scripted_agents/corrade](https://grimore.org/secondlife/scripted_agents/corrade).

## Table of Contents

- [Overview](#overview)
  - [Corrade Overview](#corrade-overview)
  - [LifeBots Overview](#lifebots-overview)
- [BotControl Command Line](#botcontrol-command-line)
  - [Requirements](#requirements)
  - [Install botctrl](#install-botctrl)
  - [Configure Corrade for use with the botctrl command](#configure-corrade-for-use-with-the-botctrl-command)
  - [Configure botctrl](#configure-botctrl)
  - [Supported Bot Actions and Examples](#supported-bot-actions-and-examples)
    - [BotControl Examples](#botcontrol-examples)
  - [Usage and Source of botctrl command](#usage-and-source-of-botctrl-command)
  - [Scheduling Bot Actions](#scheduling-bot-actions)
  - [Using the JSON return as Input](#using-the-json-return-as-input)
  - [Botctrl Help](#botctrl-help)
- [LifeBots Control Panel](#lifebots-control-panel)

## Overview

Truth &amp; Beauty Lab hosts repositories that provide a command line management
system for `Corrade` and `LifeBots` bots as well as an in-world scripted object,
`LifeBots Control Panel`, that acts as a bridge between `LifeBots` management
scripts and `LifeBots` bots.

Both `LifeBots` subscription plans provide a web UI and HUD that can be used for
interactive control of `LifeBots` bots and, for many users, this is sufficient.
There is also a `Corrade` HUD available on the marketplace. The `BotControl` project
is attempting to provide tools that go well beyond the capabilities of these HUDs
and leverage the powerful features provided by the `Corrade` and `LifeBots` API.

For developers who wish to script `LifeBots` management, command, and control, the
[LifeBots Control Panel](https://github.com/missyrestless/LifeBotsControlPanel#readme)
provides and easy to use in-world interface to the `LifeBots API`, enabling the
automation of many of the rich `LifeBots` feature set.

For those power users who wish to automate their `Corrade` and `LifeBots` bots using
the command line and tools such as `cron` and `jq`, the `botctrl` command and associated
utilities found here may provide additional power and flexibility.

The `BotControl` command line management system is open source and free to download,
deploy, modify, and distribute.

`Corrade` and `LifeBots` bots managed by the `botctrl` command line and scheduled using
the Unix `cron` facility can be viewed and interacted with in Second Life at the
[Truth & Beauty Lab](http://maps.secondlife.com/secondlife/Brightbrook%20Isle/56/135/23)
or [Club Truth & Beauty](http://maps.secondlife.com/secondlife/Scylla/226/32/78).

### Corrade Overview

The primary advantage of `Corrade` over most other Second Life bots is the
ability to self-host `Corrade` meaning I can run it on my own computers, manage
and update it myself, and my bots are not dependant on some cloud service
that may disappear at any time. This is a significant advantage.

`Corrade` is a multi-purpose, multi-platform scripted agent (bot) that runs under
Windows or Unix natively, as a service or daemon whilst staying connected to a
Linden-based grid (either Second Life or OpenSim) and controlled entirely by scripts.

The scripts in this repository are original scripting by Truth &amp; Beauty Lab.

### LifeBots Overview

[LifeBots](https://lifebots.cloud) bills itself as:

> The most advanced bot platform for Second Life. From AI characters to
> complete group automation, we've got everything your community needs.

I cannot disagree - `LifeBots` is the most advanced bot platform for Second Life. However,
`Corrade` can be self-hosted and offers a very rich API making it a reasonable free
alternative to the cloud based subscription service `LifeBots` offers.

`LifeBots` offers 2 subscription plans, `Lite` and `Full`. The plans provide these features:

| `LifeBots` Lite (`L$165/wk`) | `LifeBots` Full (`L$450/wk`) |
|:---------------------------- |:---------------------------- |
| Basic bot functionality      | All Lite Bot features        |
| Greeter Bot addon            | Group Notice scheduling      |
| HUD Support                  | Group IM scheduling          |
| Dialog Menu Interactions     | Group Web Chat               |
| RLV capabilities             | Group Discord Sync           |
| Compatible addons support    | Complete addon support       |
| API access                   | Advanced AI integration      |
| Email support                | Priority support             |
| Web dashboard access         | Custom scripting             |
| AI Access                    | AI Functions                 |
|                              | Avatar Specific Memory       |
|                              | Advanced analytics           |

## BotControl Command Line

The `BotControl Command Line` is a suite of tools that enable control and management of
`Corrade` and `LifeBots` bots via the Unix/Linux command line. These tools are executed in
a terminal using the Bash shell and utilities such as `curl`, `sed`, `awk`, `jq`, and others.

The primary command line tool is the `botctrl` Bash script which acts as a front-end
for `Corrade` and `LifeBots` API requests.

### Requirements

The `botctrl` command line management system requires:

- Unix, Linux, Macos, or Windows Subsystem for Linux (WSL)
- Bash
- Cron
- curl
- git
- [jq](https://jqlang.org)

These requirements, with the exception of `jq`, are typically included in the base
operating system on all supported platforms. If your platform does not have `jq`
installed then you can still use `botctrl`, a few of the helper utilities will not
function properly but the bulk of the system will function without `jq`.

### Install botctrl

To install `botctrl`:

```bash
git clone https://github.com/slbotcontrol/BotControl.git
cd BotControl
./install
```

Or, you can use the `curl` command to install `botctrl` with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/slbotcontrol/BotControl/refs/heads/main/install | bash
```

Alternatively, download the `install` release artifact and execute it.
The `install` script will clone the repository and install the system:

```bash
wget -q https://github.com/slbotcontrol/BotControl/releases/latest/download/install
chmod 755 install
./install
```

### Configure Corrade for use with the botctrl command

Version 2 and later of the `botctrl` command supports command and control of both
`LifeBots` and `Corrade` bots.

In order to use the `botctrl` command to manage your `Corrade` bot(s):

- The HTTP server must be enabled in the `Corrade` configuration
- `ScriptLanguage` must be set to `JSON` in the `Corrade` configuration

Example snippet to enable the HTTP server in `CorradeConfiguration.xml`:

```xml
<Servers>
    <HTTPServer>
        <Enable>1</Enable>
        <Prefixes>
            <Prefix>http://+:8082/</Prefix>
        </Prefixes>
    </HTTPServer>
    ...
</Servers>
```

Set the port number in the `Prefix` configuration to an open unused port.
If you have more than one `Corrade` bot then use a different port for each.

To set the `ScriptLanguage` to JSON in `CorradeConfiguration.xml`:

```xml
  <ScriptLanguage>JSON</ScriptLanguage>
```

### Configure botctrl

The `botctrl` command is installed in `/usr/local/bin` along with some
utility scripts for use with `cron` or other management systems. These
utility scripts will need to be modified to suit your specific needs,
configuration and bot names. You can modify the scripts in
`bin/` and re-run `./install`.

Add `/usr/local/bin` to your execution `PATH` if it is not already included.

Configure `botctrl` by adding and editing the file `${HOME}/.botctrl`.

If you wish to control `LifeBots` bots then you must configure your `LifeBots`
developer API key and bot secrets for the `LifeBots` bots you wish to control.

If you wish to control `Corrade` bots then you must configure your `Corrade`
group, password, and server URL.

The following example entries in `$HOME/.botctrl` will allow you to control a
`LifeBots` bot named "Your Botname" and a `Corrade` bot named "Cory Bot":

```bash
# Minimum contents of $HOME/.botctrl
#
# LifeBots Developer API Key
export LB_API_KEY='<your-lifebots-api-key>'
# LifeBots bot secret
export LB_SECRET_Your_Botname='<your-bot-secret>'
# Corrade Group, Password, and Server URL
export CORRADE_GROUP="<your-corrade-bot-group-name>"
export CORRADE_PASSW="<your-corrade-bot-group-password>"
export CORRADE_URL="https://your.corrade.server"
# The Corrade bot's API URL
# This assumes a reverse proxy setup has been configured and this URL
# path is passed by the web server to the appropriate Corrade HTTP port
export API_URL_Cory_Bot="${CORRADE_URL}/cory/"
```

Add an entry of the form `export LB_SECRET_Firstname_Lastname='<bot-secret>'`
to `$HOME/.botctrl` for each of your `LifeBots` bots.

Add an entry of the form `export API_URL_Firstname_Lastname="${CORRADE_URL}/path/"`
to `$HOME/.botctrl` for each of your `Corrade` bots.

See `BotControl/example_dot_botctrl` for a template to use for `$HOME/.botctrl`.

See `BotControl/crontab.in` for example crontab entries to schedule bot activities.

See the section [Scheduling Bot Actions](#scheduling-bot-actions) below for more
details on scheduling bot actions.

### Supported Bot Actions and Examples

The `botctrl` command supports a significant subset of the full `LifeBots` API
and a substantial and growing subset of the extensive `Corrade` API.

#### Basic Commands

- `bot_location` : get precise bot location
- `key2name` : convert an avatar UUID to avatar name
- `login` : login bot
- `logout` : logout bot
- `name2key` : convert an avatar name to avatar UUID
- `status` : get bot status

#### Movement Commands

- `sit` : sit on a specified object UUID
- `stand` : make bot stand up
- `teleport` : teleport bot to specified location
- `walkto` : walk bot to a location

#### Communication

- `im` : send an instant message to an avatar
- `reply_dialog` : reply to a dialog menu (requires channel, UUID, and button text)
- `say_chat_channel` : send a message to the specified chat channel
- `send_group_im` : send an instant message to a group
- `send_notice` : send an official group notice to all group members

#### Inventory Management

- `get_outfit` : list currently worn bot outfit
- `get_outfits` : list available bot outfits
- `listinventory` : list bot inventory, optionally specify an inventory folder UUID
- `set_hoverheight` : adjust bot hover height
- `takeoff` : remove a worn item
- `wear` : wear an inventory item (uses "add" rather than "wear")
- `wear_outfit` : wear a specified outfit

#### Group Management

- `activate_group` : activate a group tag

#### Money &amp; Transactions

- `get_balance` : get your bot's L$ balance
- `give_money` : pay another avatar L$ from your bot
- `give_money_object` : pay an object L$ from your bot

#### Object Interaction

- `attachments` : list bot attachments, optionally specify a filter to match
- `touch_attachment` : touch a specified bot attachment
- `touch_prim` : touch a specified object by UUID

#### BotControl Configuration

- `listalias` : list configured `botctrl` aliases in `$HOME/.botctrl`

#### BotControl Examples

<details><summary>Click here to view an

**example demonstrating outfit change and capturing return value**

</summary>

```bash
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
```

</details>

**[NOTE:]** the examples below all assume you have configured `$HOME/.botctrl`
with your `LifeBots` API key and the bot secret:

```bash
# LifeBots Developer API Key
export LB_API_KEY='<redacted>'
# John Doebot LifeBots secret
export LB_SECRET_John_Doebot='<redacted>'
```

<details><summary>Click here to view the

**botctrl command examples**

</summary>

The following actions and commands, along with example command line invocations,
are supported by the `botctrl` command.

- `activate_group` : activate a group tag
  - `Example` : activate the specified group tag for bot `John Doebot`
  - `botctrl -a activate -n "John Doebot" -u "f8e95201-20af-b85f-a682-7ac25ab9fcaf"`
    - If `~/.botctrl` contains : `export UUID_pay2play="f8e95201-20af-b85f-a682-7ac25ab9fcaf"`
    - `botctrl -a activate -n "John Doebot" -u pay2play`
- `attachments` : list bot attachments, optionally specify a filter to match
  - `Example` : list bot named `John Doebot` attachments with name containing the string `HUD`
  - `botctrl -a attachments -F "HUD" -n "John Doebot"`
- `bot_location` : get precise bot location
  - `Example` : get location of bot named `John Doebot`
  - `botctrl -a location -n "John Doebot"`
- `get_balance` : get your bot's L$ balance
  - `Example` : get the L$ balance of bot `John Doebot`
  - `botctrl -a balance -n "John Doebot"`
- `get_outfit` : list currently worn bot outfit
  - `Example` : list currently worn outfit of bot named `John Doebot`
  - `botctrl -a get_outfit -n "John Doebot"`
- `get_outfits` : list available bot outfits
  - `Example` : list available outfits for bot named `John Doebot`
  - `botctrl -a get_outfits -n "John Doebot"`
- `give_money` : pay another avatar L$ from your bot
  - `Example` : pay avatar with specified UUID L$300 from bot `John Doebot`
  - `botctrl -a give_money -n "John Doebot" -u "3506213c-29c8-4aa1-a38f-e12f6d41b804" -z 300`
- `give_money_object` : pay an object L$ from your bot
  - `Example` : pay a tip jar with specified UUID L$100 from bot `John Doebot`
  - `botctrl -a give_money_object -n "John Doebot" -u "47cb1fc7-8144-b538-6716-c723fb1332d6" -z 100`
- `im` : send an instant message to an avatar
  - `Example` : send IM from `John Doebot` to avatar "Jane Free"
  - `botctrl -a im -n "John Doebot" -N "Jane Free" -M 'Hi Jane, do you want to meetup?'`
- `key2name` : convert an avatar UUID to avatar name
  - `Example` : use `John Doebot` bot to get avatar name of specified UUID
  - `botctrl -a key2name -n "John Doebot" -u "3506213c-29c8-4aa1-a38f-e12f6d41b804"`
- `listalias` : list configured `botctrl` aliases in `$HOME/.botctrl`
  - `Example` : list all configured `botctrl` aliases
  - `botctrl -a listalias`
  - `Example` : list configured `botctrl` bot aliases only
  - `botctrl -a botalias`
  - `Example` : list configured `botctrl` location aliases only
  - `botctrl -a slurlalias`
  - `Example` : list configured `botctrl` UUID aliases only
  - `botctrl -a uuidalias`
- `listinventory` : list bot inventory, optionally specify an inventory folder UUID
  - `Example` : list inventory of bot named `John Doebot`
  - `botctrl -a listinventory -n "John Doebot"`
- `login` : login bot
  - `Example` : login bot named `John Doebot`
  - `botctrl -a login -n "John Doebot"`
- `logout` : logout bot
  - `Example` : logout bot named `John Doebot`
  - `botctrl -a logout -n "John Doebot"`
- `name2key` : convert an avatar name to avatar UUID
  - `Example` : use `John Doebot` bot to get avatar UUID of Missy Restless
  - `botctrl -a name2key -n "John Doebot" -N "Missy Restless"`
- `reply_dialog` : reply to a dialog menu (requires channel, UUID, and button text)
  - `Example` : click couch menu button "Male" on channel 99999
  - `botctrl -a reply -n "John Doebot" -C 99999 -B Male -u "a811d6fe-de59-2f4e-ee19-0cc48da48981"`
- `say_chat_channel` : send a message to the specified chat channel
  - `Example` : send a message on channel 0, visible to everyone nearby
  - `botctrl -a say -n "John Doebot" -C 0 -M "Hi everyone, you look great"`
- `send_group_im` : send an instant message to a group
  - `Example` : send IM to a group from bot named `John Doebot`
  - `botctrl -a send_group_im -n "John Doebot" -u "f7d3c1b9-a141-9546-7e2d-dfd698c5df7c" -M "Meeting at Noon SLT tomorrow"`
- `send_notice` : send an official group notice to all group members
  - `Example` : send group notice with subject and message from bot named `John Doebot`
  - `botctrl -a send_notice -n "John Doebot" -u "f7d3c1b9-a141-9546-7e2d-dfd698c5df7c" -M "Meeting at Noon SLT tomorrow" -S "Meeting Tomorrow"`
- `set_hoverheight` : adjust bot hover height
  - `Example` : lower hover height of bot `John Doebot` by 0.05
  - `botctrl -a height -n "John Doebot" -z "-0.05"`
- `sit` : sit on a specified object UUID
  - `Example` : sit bot named `John Doebot` on an object
  - `botctrl -a sit -n "John Doebot" -u "d46e217b-fb5c-4796-bae3-ea016b280210"`
- `stand` :  make bot stand up
  - `Example` : make bot `John Doebot` stand up
  - `botctrl -a stand -n "John Doebot"`
- `status` : get bot status
  - `Example` : get status of bot `John Doebot` (status is default action)
  - `botctrl -n "John Doebot"`
- `takeoff` : remove a worn item
  - `Example` : bot `John Doebot` remove the specified inventory item
  - `botctrl -a takeoff -n "John Doebot" -u "d666e910-ba72-0c11-a66e-c3759d8af0f5"`
- `teleport` : teleport bot to specified location
  - `Example` : teleport bot `John Doebot` to the aliased location "club"
  - Requires an entry of the following form in `$HOME/.botctrl`
    - `export SLURL_club="http://maps.secondlife.com/secondlife/Scylla/226/32/78"`
  - `botctrl -a teleport -n "John Doebot" -l club`
- `touch_attachment` : touch a specified bot attachment
  - `Example` : bot `John Doebot` touch attachment named "HUD Controller"
  - `botctrl -a touch_attachment -n "John Doebot" -O "HUD Controller"`
- `touch_prim` : touch a specified object by UUID
  - `Example` : bot named `John Doebot` touch an object
  - `botctrl -a touch_prim -n "John Doebot" -u "f11781d0-763f-52f9-4e23-3a2b97759fa2"`
    - If `~/.botctrl` contains : `export UUID_spoton="f11781d0-763f-52f9-4e23-3a2b97759fa2"`
    - `botctrl -a touch_prim -n "John Doebot" -u spoton`
- `walkto` : walk bot to a location
  - `Example` : bot named `John Doebot` walk to X/Y/Z coordinates 100/50/28
  - `botctrl -a walkto -n "John Doebot" -l "100/50/28"`
- `wear` : wear an inventory item (uses "add" rather than "wear")
  - `Example` : bot `John Doebot` wear the specified inventory item
  - `botctrl -a wear -n "John Doebot" -u "d666e910-ba72-0c11-a66e-c3759d8af0f5"`
- `wear_outfit` : wear a specified outfit
  - `Example` : bot named `John Doebot` wear the outfit named "Business Casual"
  - `botctrl -a wear_outfit -n "John Doebot" -O "Business Casual"`
    - If `~/.botctrl` contains : `export LB_BOT_NAME='John Doebot'`
    - `botctrl -a wear_outfit -O "Business Casual"`

</details>

Development is in rapid progress for additional actions.

Let us know which `Corrade` or `LifeBots` API requests you would like supported.

### Usage and Source of botctrl command

<details><summary>Click here to view the

**botctrl command usage message**

</summary>

```
Usage: botctrl [-deih] [-a action] [-A avatar] [-l location] [-n name] [-k apikey] [-C channel] [-c corrade]
  [-D data] [-F filter] [-M message] [-N name] [-O name] [-S subject] [-s secret] [-T text] [-u uuid] [-z num]
Where:
	-a action specifies the API action (sit, teleport, login, ...)
	-l location specifies a location for login and teleport actions
		Default: Last location, teleport action requires a Slurl location
	-n name specifies a Bot name, Default: Easy Islay
	-k apikey specifies an API Key, use environment instead
	-A avatar specifies an avatar UUID for use with giving money or objects
	-C channel specifies the channel for a message [default: 0]
	-c corrade specifies a Corrade bot name to act upon
	-D data specifies a Corrade Manager class member
	-F filter specifies a filter to match when listing attachments
	-M message specifies the message body for a group notice/im
	-N name specifies the name of the recipient of an IM or landmark/notecard
	-O name specifies an attachment object name or outfit name
	-S subject specifies the subject for a group notice
	-s secret specifies a Bot secret, use environment instead
	-T text specifies the notecard text or dialog button text for reply to menus
	-u uuid specifies a UUID for use with actions that require one (e.g. sit)
	-z num specifies a hover height adjustment size [default: -0.05]
		can also be used to specify a payment amount
	-d indicates dryrun mode - tell me what you would do without doing anything
	-e displays a list of supported commands and examples then exits
	-i retrieves Bot details
	-h displays this usage message and exits

Environment:
  Entries in ~/.botctrl can be LB_API_KEY, LB_SECRET, or entries
  of the form LB_SECRET_BOT_NAME in order to support multiple bots
  Entries can specify a Slurl alias. For example:
    export SLURL_club='http://maps.secondlife.com/secondlife/Scylla/226/32/78'
  A Slurl alias can be used with the -l command line argument, e.g. -l club
  Entries can also specify a UUID alias. For example:
    export UUID_Mover='xxxxxxxx-yyyy-zzzz-aaaa-bbbbbbbbbbbb'
  A UUID alias can be used with the -u command line argument, e.g. -u Mover

Examples:
  botctrl  # Displays the status of the default Bot
  botctrl -a login -l Home # Default Bot login to Home location
  botctrl -a touch_prim -n 'Jane Doe' -u Mover # Jane Doe bot touch object with aliased UUID
  botctrl -a stand -n Jane -c John # Jane bot sends the stand command to Corrade bot John
  botctrl -a teleport -l club  # Uses a 'club' location alias defined in .botctrl

Supported Actions
Supported actions for BotControl Configuration:
  bot_alias, loc_alias, slurl_alias, uuid_alias, list_alias, alias
Supported actions common to both Corrade and LifeBots:
  activate_group, attachments, avatar_picks, get_balance, get_outfit, get_outfits, give_inventory,
  give_object, give_money, give_money_object, im, key2name, listinventory, login, logout,
  name2key, notecard_create, rebake, say_chat_channel, send_group_im, send_notice,
  set_hoverheight, sit, stand, status, takeoff, teleport, touch_prim, walkto, wear, wear_outfit
Supported actions for LifeBots only:
  bot_location, reply_dialog, touch_attachment
Supported actions for Corrade only:
  attach, conference, conference_detail, conference_list, createlandmark, currentsim, detach
  fly, flyto, getattachmentspath, getavatarpickdata, getgroupmemberdata, get_hoverheight,
  getmembersonline, getregiontop, getselfdata, inventory cwd, networkmanagerdata
```

</details>

### Scheduling Bot Actions

**[Note:]** A more modern approach to scheduled LifeBots activities is available
as a `LifeBots Add-On` with the `Routine Planner Add-On` at
[https://lifebots.cloud/store/addon/routine-planner](https://lifebots.cloud/store/addon/routine-planner).
With `Routine Planner` you can build fully automated, interactive bot behaviors using
routines that run on schedules, react to chat/IM triggers, execute actions step-by-step,
and even branch routines based on user responses.

The Truth & Beauty Lab utilizes the `Cron` subsystem on Linux and Macos to
schedule bot actions. Truth & Beauty Lab bots are logged in, teleported
to various locations, seated on various objects, and engaged in a variety of
activities using `crontab` entries that execute `Corrade` and `LifeBots` API
requests at scheduled times. Here is an example `crontab` entry with some brief
descriptions in comments of what activities are scheduled:

```
SHELL=/bin/bash
#
# Schedule BotControl actions
# -------------------------
# Uses the botctrl command line tool at:
#   https://github.com/slbotcontrol/BotControl/blob/main/botctrl
# Assumes some configuration in ~/.botctrl has been performed
#
# m h  dom mon dow   command
#
# Weekdays send Anya bot to the club at midnight
0 0 * * 1-5 /bin/bash -lc /usr/local/BotControl/anya2club >> /usr/local/BotControl/log/cron.log 2>&1
# Weekends send Anya bot to the beach at 11am
0 11 * * 0,6 /bin/bash -lc /usr/local/BotControl/anya2beach >> /usr/local/BotControl/log/cron.log 2>&1
# Monday at 4pm send Anya bot to DJ at the Media Sphere
0 16 * * 1 /bin/bash -lc /usr/local/BotControl/anya2msdj >> /usr/local/BotControl/log/cron.log 2>&1
# Monday at 6pm sit Anya in theater seating after her set
0 18 * * 1 /bin/bash -lc /usr/local/BotControl/anya2seat >> /usr/local/BotControl/log/cron.log 2>&1
# Tuesday at 6pm send Angelus bot to DJ at the club
0 18 * * 2 /bin/bash -lc /usr/local/BotControl/angelus2clubdj >> /usr/local/BotControl/log/cron.log 2>&1
# Tuesday at 8pm send Angelus bot back to his dance pole
0 20 * * 2 /bin/bash -lc /usr/local/BotControl/angelus2pole >> /usr/local/BotControl/log/cron.log 2>&1
# Friday at 6pm send Easy bot to DJ at the club
0 18 * * 5 /bin/bash -lc /usr/local/BotControl/easy2clubdj >> /usr/local/BotControl/log/cron.log 2>&1
# Friday at 8pm send Easy bot back to her dance pole
0 20 * * 5 /bin/bash -lc /usr/local/BotControl/easy2pole >> /usr/local/BotControl/log/cron.log 2>&1
# Saturday at 6pm send all bots to dance at the club
0 18 * * 6 /bin/bash -lc /usr/local/BotControl/bots2clubdance >> /usr/local/BotControl/log/cron.log 2>&1
# Saturday at 9pm send all bots back to their default locations
0 21 * * 6 /bin/bash -lc /usr/local/BotControl/bots2home >> /usr/local/BotControl/log/cron.log 2>&1
# Check every hour if Easy bot is at the club greeting visitors
# 0 * * * * /bin/bash -lc /usr/local/BotControl/checkbot >> /usr/local/BotControl/log/cron.log 2>&1
# Send the Easy Islay bot's L$ balance to myself on the 1st of every month
# 0 0 1 * * /bin/bash -lc /usr/local/BotControl/send_easy_balance >> /usr/local/BotControl/log/easy.log 2>&1
```

Here is the code for one of the control scripts, the `checkstatus` script that
reports the online/offline status of configured bots:

```bash
#!/usr/bin/env bash
#
# checkstatus - get status of a Corrade and LifeBots bots
#
# Usage: checkstatus [-n name]

# Default bot
DEF_BOT="Anya"
# All bots
ALL_CO_BOTS="Angel Easy"
ALL_LB_BOTS="Anya"
ALL_BOTS="${ALL_CO_BOTS} ${ALL_LB_BOTS}"

export PATH="/usr/local/bin:${PATH}"
[ -d /opt/homebrew/bin ] && {
  export PATH="/opt/homebrew/bin:${PATH}"
}

have_lb=$(type -p botctrl)
[ "${have_lb}" ] || {
  echo "ERROR: cannot locate botctrl in PATH"
  exit 1
}

have_jq=$(type -p jq)

usage() {
  printf "\nUsage: checkstatus [-A] [-c|l] [-n name]\n\n"
  printf "\nWhere:"
  printf "\n\t-A indicates check status of all bots [All Bots: ${ALL_BOTS}]"
  printf "\n\t-c indicates use Corrade API to perform check"
  printf "\n\t-l indicates use LifeBots API to perform check"
  printf "\n\t-n name specifies the BOT name [default: ${DEF_BOT}]\n\n"
  exit 1
}

check_co_bot() {
  local slbot="$1"
  # Check for Name alias in ~/.botctrl
  local SL_NAME="${slbot}"
  local botname=$(echo "${slbot}" | sed -e "s/ /_/g")
  local envname="BOT_NAME_${botname}"
  [ "${!envname}" ] && SL_NAME="${!envname}"
  if botctrl -a status -c "${SL_NAME}" 2>&1 | grep 'parse error' >/dev/null; then
    STATUS="OFFLINE"
  else
    STATUS="ONLINE"
  fi
  if [ "${have_jq}" ]; then
    printf "\n{\n  \"action\": \"status\",\n  \"status\": \"${STATUS}\",\n  \"slname\": \"${SL_NAME}\"\n}\n" | jq -r .
  else
    printf '\n{'
    printf '\n  "action": "status",'
    printf "\n  \"status\": \"${STATUS}\","
    printf "\n  \"slname\": \"${SL_NAME}\""
    printf '\n}\n'
  fi
  sleep 2
}

BOT= allbots=1 corrade= lifebot=
while getopts ":Acln:h" flag; do
  case $flag in
    A)
      allbots=1
      ;;
    c)
      corrade=1
      ;;
    l)
      lifebot=1
      ;;
    n)
      BOT="$OPTARG"
      allbots=
      ;;
    h)
      usage
      ;;
    \?)
      echo "Invalid option: $flag"
      usage
      ;;
  esac
done
shift $(( OPTIND - 1 ))

[ "${corrade}" ] && [ "${lifebot}" ] && {
  echo "Only one of -c and -l can be specified. Exiting."
  exit 1
}
[ "${BOT}" ] && {
  [ "${corrade}" ] || [ "${lifebot}" ] || {
    echo "One of -c or -l must be given when specifying bot name with -n name. Exiting."
    exit 1
  }
}

[ "${BOT}" ] || BOT="${DEF_BOT}"

[ -f ${HOME}/.botctrl ] && source ${HOME}/.botctrl

if [ "${allbots}" ]; then
  [ "${ALL_LB_BOTS}" ] && {
    for bot in ${ALL_LB_BOTS}
    do
      if [ "${have_jq}" ]; then
        botctrl -a status -n ${bot} | jq -r '{action: .action, status: .status, slname: .slname}'
      else
        botctrl -a status -n ${bot}
      fi
      sleep 2
    done
  }
  [ "${ALL_CO_BOTS}" ] && {
    for bot in ${ALL_CO_BOTS}
    do
      check_co_bot "${bot}"
    done
  }
else
  if [ "${corrade}" ]; then
    check_co_bot "${BOT}"
  else
    if [ "${have_jq}" ]; then
      botctrl -a status -n ${BOT} | jq -r '{action: .action, status: .status, slname: .slname}'
    else
      botctrl -a status -n ${BOT}
    fi
  fi
fi
```

This script uses a couple of aliases defined in `$HOME/.botctrl`, the `club`
location alias and the `Easy` bot name alias:

```bash
export BOT_NAME_Easy="Easy Islay"
export SLURL_club="http://maps.secondlife.com/secondlife/Scylla/226/32/78"
```

Aliases provide some convenience. For example, the command

```bash
botctrl -a teleport -n Easy -l club
```

is just an easier way of issuing the command

```bash
botctrl -a teleport -n "Easy Islay" -l "http://maps.secondlife.com/secondlife/Scylla/226/32/78"
```

### Using the JSON return as Input

The `botctrl` command returns a JSON object containing the results of the API request. This
object can be parsed with `jq` and the return values used as input to another `botctrl` command.

For example, if you want to send all of the L$ balance of your bot to yourself:

```bash
#!/usr/bin/env bash
#
# send_bot_balance - get the bot's balance and send it to myself
#
# Usage: send_bot_balance [-A] [-n bot_name] [-N recipient_name] [-u uuid]

# Set this to your Second Life avatar name
DEF_SL_NAME="Missy Restless"
# Set this to your bot's name
DEF_BOT_NAME="Easy"
# Set this to all your bots names or their aliases, for use with -A
ALL_LB_BOTS="Anya"
ALL_CO_BOTS="Angel Easy"
ALL_BOTS="${ALL_LB_BOTS} ${ALL_CO_BOTS}"
CORRADE=

export PATH="/usr/local/bin:${PATH}"
[ -d /opt/homebrew/bin ] && {
  export PATH="/opt/homebrew/bin:${PATH}"
}

have_lb=$(type -p botctrl)
[ "${have_lb}" ] || {
  echo "ERROR: cannot locate botctrl in PATH"
  exit 1
}

have_jq=$(type -p jq)
[ "${have_jq}" ] || {
  echo "ERROR: cannot locate jq in PATH"
  exit 1
}

usage() {
  printf "\nUsage: send_bot_balance [-A] [-d] [-n bot_name] [-N recipient_name]\n\n"
  printf "\nWhere:"
  printf "\n\t-A indicates all bots [All Bots: ${ALL_BOTS}]"
  printf "\n\t-d indicates debug mode, no payment [default: false]"
  printf "\n\t-n name specifies the BOT name [default: ${DEF_BOT_NAME}]"
  printf "\n\t-N recipient_name specifies the payment recipient [default: ${DEF_SL_NAME}]\n\n"
  exit 1
}

send_balance() {
  local bot_type="$1"
  local bot_arg="-n"
  local BALANCE=0

  CORRADE=
  if [ "${bot_type}" == "-c" ]; then
    bot_arg="-c"
    CORRADE=1
  else
    if [ "${bot_type}" == "-l" ]; then
      bot_arg="-n"
      CORRADE=
    else
      echo "${ALL_LB_BOTS}" | grep "${BOT_NAME}" >/dev/null || {
        bot_arg="-c"
        CORRADE=1
        echo "${ALL_CO_BOTS}" | grep "${BOT_NAME}" >/dev/null || {
          echo "Unable to determine bot type. Unknown bot."
          exit 1
        }
      }
    fi
  fi
  # Get the bot's balance
  [ "${debug}" ] && {
    echo "Getting bot balance with:"
    if [ "${CORRADE}" ]; then
      echo "botctrl -a balance ${bot_arg} \"${BOT_NAME}\" | jq -r '.data[0]'"
    else
      echo "botctrl -a balance ${bot_arg} \"${BOT_NAME}\" | jq -r '.balance'"
    fi
  }
  if [ "${CORRADE}" ]; then
    BALANCE=$(botctrl -a balance ${bot_arg} "${BOT_NAME}" | jq -r '.data[0]')
  else
    BALANCE=$(botctrl -a balance ${bot_arg} "${BOT_NAME}" | jq -r '.balance')
  fi
  [ "${BALANCE}" ] || {
    echo "ERROR: cannot get bot ${BOT_NAME} balance"
    exit 1
  }

  # Send balance if it is greater than 0
  [ "${debug}" ] && echo "Balance = ${BALANCE}"
  [ ${BALANCE} -gt 0 ] && {
    [ "${debug}" ] && {
      echo "Sending bot balance to ${SL_NAME} with:"
      echo "botctrl -a give_money ${bot_arg} \"${BOT_NAME}\" -A \"${SL_UUID}\" -z ${BALANCE} ${debug}"
    }
    botctrl -a give_money ${bot_arg} "${BOT_NAME}" -A "${SL_UUID}" -z ${BALANCE} ${debug}
  }
}

BOT_NAME= SL_NAME=
allbots=
debug=
while getopts ":Adn:N:h" flag; do
  case $flag in
    A)
      allbots=1
      ;;
    d)
      debug="-d"
      ;;
    n)
      BOT_NAME="$OPTARG"
      ;;
    N)
      SL_NAME="$OPTARG"
      ;;
    h)
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
[ "${SL_NAME}" ] || SL_NAME="${DEF_SL_NAME}"

CORRADE=
echo "${ALL_LB_BOTS}" | grep "${BOT_NAME}" >/dev/null || {
  CORRADE=1
  echo "${ALL_CO_BOTS}" | grep "${BOT_NAME}" >/dev/null || {
    echo "Unable to determine bot type. Unknown bot."
    exit 1
  }
}

if [ "${CORRADE}" ]; then
  SL_UUID=$(botctrl -a name2key -c "${BOT_NAME}" -N "${SL_NAME}" | jq -r '.data[1]')
else
  SL_UUID=$(botctrl -a name2key -n "${BOT_NAME}" -N "${SL_NAME}" | jq -r '.key') 
fi
[ "${SL_UUID}" ] || {
  echo "ERROR: cannot get UUID for Second Life avatar name ${SL_NAME}"
  exit 1
}

if [ "${allbots}" ]; then
  [ "${ALL_LB_BOTS}" ] && {
    for bot in ${ALL_LB_BOTS}
    do
      BOT_NAME="${bot}"
      [ "${BOT_NAME}" ] || {
        echo "ERROR: empty bot name"
        exit 1
      }
      send_balance -l
    done
  }
  [ "${ALL_CO_BOTS}" ] && {
    for bot in ${ALL_CO_BOTS}
    do
      BOT_NAME="${bot}"
      [ "${BOT_NAME}" ] || {
        echo "ERROR: empty bot name"
        exit 1
      }
      send_balance -c
    done
  }
else
  [ "${BOT_NAME}" ] || {
    echo "ERROR: empty bot name"
    exit 1
  }
  send_balance
fi
```

A script like this could be used to automate transfer of L$ from your bots to your
primary avatar. For example, automated transfer of a bot's L$ balance on the 1st of
every month could be setup to run as a `cron` job with the following `crontab` entry:

```
# Send the Easy Islay bot's L$ balance to myself on the 1st of every month
0 0 1 * * /bin/bash -lc /usr/local/BotControl/send_easy_balance >> /usr/local/BotControl/log/easy.log 2>&1
```
### Botctrl Help

View the `botctrl` usage message via the command `botctrl -h`.

View `botctrl` examples and supported commands via the command `botctrl -e`.

View the `botctrl` manual via the command `man botctrl` or
[view the manual online](https://github.com/slbotcontrol/BotControl/blob/main/markdown/botctrl.1.md).

Issues can be reported at https://github.com/slbotcontrol/BotControl/issues

## LifeBots Control Panel

**[Note:]** `LifeBots Control Panel` has moved to its own repository at
[https://github.com/missyrestless/LifeBotsControlPanel](https://github.com/missyrestless/LifeBotsControlPanel)

`LifeBots Control Panel` is an LSL script library to control `LifeBots` bots from an LSL script.

The `LifeBots Control Panel` is a scripted in-world object that acts as a bridge between your
LifeBots management scripts and your LifeBots bots. The control panel communicates with your bots
using the `LifeBots API` and an HTTP server listening to events.
