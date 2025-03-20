This (very rudimentary) script autodetects your default microphone and an app of your choosing's output into a virtual microphone. This allows you to both talk and play music in games or voice calls through your microphone.

Limitations:
1. Chromium/Electron apps are really weird with PipeWire and all look the same in the output list.
2. Pipewire will only list apps that are CURRENTLY playing audio. It would probably be possible to make it loop and collect multiple apps to pick from over a 5 second span, but this script was designed to be fast and easy.

3. Cool name credit goes to: Justin Li
