#!/bin/bash


# find what you want to link with "pw-link -o"
# it only finds things that are currently playing audio
#This script operates under the distinction that the app and the mic are both two channel. If it is a mono mic or a mono output, you can probably just set the mono mic to both FL and FR without problems... probably."
app_FL=fooyin:output_FL
app_FR=fooyin:output_FR

# "pw-link -o" for here too
#mic_FL=alsa_input.usb-FIFINE_Microphones_FIFINE_K780A_Microphone_REV1.0-00.analog-stereo:capture_FL
#mic_FR=alsa_input.usb-FIFINE_Microphones_FIFINE_K780A_Microphone_REV1.0-00.analog-stereo:capture_FR
mic_FL="$(pactl get-default-source):capture_FL"
mic_FR="$(pactl get-default-source):capture_FL"
if [[ `pw-link -o | grep $mic_FL ` ]]; then echo "mic_FL autodetected from default mic"; fi
if [[ `pw-link -o | grep $mic_FR ` ]]; then echo "mic_FR autodetected from default mic"; fi
echo "Default is $(pactl get-default-source)"

# these create the combined sink and the virtual mic
pactl load-module module-null-sink media.class=Audio/Sink sink_name=my-combined-sink channel_map=stereo
pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=my-virtualmic channel_map=front-left,front-right

echo "Program you're trying to link to the sink usually has to be playing audio to link at the beginning. If this says failed to link ports, that is probably why"
pw-link $app_FL my-combined-sink:playback_FL
pw-link $app_FR my-combined-sink:playback_FR

pw-link $mic_FL  my-combined-sink:playback_FL
pw-link $mic_FR  my-combined-sink:playback_FR

# then the combined sink gets linked to the virtual mic
pw-link my-combined-sink:monitor_FL my-virtualmic:input_FL
pw-link my-combined-sink:monitor_FR my-virtualmic:input_FR

echo "Combined microphone created."
echo "Press any key to stop the combined microphone..."
echo "Stopping usually breaks Discord and some other programs, for Discord specifically just restart it."

# if user presses anything, we restart pipewire so settings get reset
read -n 1
systemctl --user restart pipewire

# Notes
# Vesktop and th-ch's Youtube Music App both use Chromium/Electron which makes it difficult/impossible to differentiate them in "pw-link -o" because both are listed as Chromium. This problem only becomes worse if you are also using a Chromium based browser such as Chrome, Vivaldi, and others. No clue if there is a fix. Solution I suggest if you are trying to play music from a Chromium/Electron based app, just don't.
# Another thing to keep in mind is that Discord's input sensitivity will take effect on your virtual microphone, causing it to blink in and out. Slightly annoying, so I recommend using this in game only unless you have fancy schmancy voice activity that won't kill the audio.

# this is very rudimentary code, mostly copy pasting from other various websites and throwing it in a blender and running it and praying.

# in the future I might update this script to be more interactive and user friendly. would probably have to run pw-link -o, print it, ask the user which ones to link. probably wouldn't be too hard. probably.
