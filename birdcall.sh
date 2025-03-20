#!/bin/bash


# NOW PRESENTING
# A SUPER OVER-COMPLICATED SCRIPT THAT COULD PROBABLY BE MADE SIMPLER
# VERSION 2

# NAME CREDIT GOES TO -- JUSTIN LI

# if it wasnt fucking obvious i code like someone who's teaching themselves off the finest web searches
# requirements: bash gum pipewire pipewire-pulse
# WORLD OF COLOR
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

center() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' -{1..500})"
  printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

disconnect() {
pw-link -d combined-sink:monitor_FL virtualmic:input_FL
pw-link -d combined-sink:monitor_FR virtualmic:input_FR

pw-link -d $mic_FL  combined-sink:playback_FL
pw-link -d $mic_FR  combined-sink:playback_FR

pw-link -d $app_FL combined-sink:playback_FL
pw-link -d $app_FR combined-sink:playback_FR

pactl unload-module module-null-sink
printf "\n"
exit
}

# app selection ||| also assuming you have apps and speakers which arent mono. if you do, that is unfortunate
printf ${CYAN}
center "Which app would you like to go into the virtual microphone?"
tmpout=$(mktemp)
trap "rm -f $tmpout" EXIT
pw-link -o | grep FL | sed 's/...$//' | gum choose --height=15 | cat > $tmpout
app="$(cat $tmpout)"
app_FL="${app}_FL"
app_FR="${app}_FR"

# mic selection
echo -e "Default microphone is:${LIGHTRED} $(pactl get-default-source) ${NOCOLOR}"
mic_FL="$(pactl get-default-source):capture_FL"
mic_FR="$(pactl get-default-source):capture_FL"

# these create the combined sink and the virtual mic
# dunno why yet but the media.class bit is required
pactl load-module module-null-sink media.class=Audio/Sink sink_name=combined-sink channel_map=stereo > /dev/null
pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=virtualmic channel_map=front-left,front-right > /dev/null

# link up the app FL/FR and the mic FL/FR to the combined sink
pw-link $app_FL combined-sink:playback_FL
pw-link $app_FR combined-sink:playback_FR

pw-link $mic_FL  combined-sink:playback_FL
pw-link $mic_FR  combined-sink:playback_FR

# then the combined sink gets linked to the virtual mic
pw-link combined-sink:monitor_FL virtualmic:input_FL
pw-link combined-sink:monitor_FR virtualmic:input_FR

echo "Combined microphone created."
echo "Press any key to stop the combined microphone..."

read -n 1
disconnect

# LIMITATIONS
# STILL NO SUPPORT FOR MONO MICROPHONES
# IF SOMEBODY OTHER THAN ME EVER USES THIS PIECE OF SHIT I WILL FIX IT THEN
# REQUIRES THE APP OUTPUT YOU CHOOSE TO BE CURRENTLY PLAYING AUDIO
# EXCEPT FOR DISCORD BECAUSE DISCORD IS SPECIAL AND IS SOMEHOW CONSTANTLY PLAYING FUCKING AUDIO AND IS ALWAYS LISTED AS CHROMIUM WHICH MAKES IT A FUCKING PAIN TO PICK ANY OTHER CHROMIUM OUTPUT BECAUSE THEY LOOK THE SAME
