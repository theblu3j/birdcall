This (very rudimentary) script autodetects your default microphone and an app of your choosing's output into a virtual microphone. This allows you to both talk and play music in games through your microphone.

Limitations:
1. Chromium/Electron apps are really weird with PipeWire and all look the same in the output list. This includes Chrome/Chromium, Discord, etc. However, PipeWire auto removes any apps from output list if they are not actively trying to play audio, so as long as you have the one you want to route currently playing audio and none others it should be easy.
2. That last thing also means it cannot route audio into your app at the beginning without it actively playing audio. I could probably make it loop and keep trying until it succeeds in finding your app of choice, but I am a complete amateur.
3. There is no TUI yet. To select which app you want to route into the virtual microphone, you have to use 'pw-link -o', find your app's outputs, and put them into the script. Finding default mic is pretty easy so that's already done.
4. Some apps really don't like PipeWire being restarted when the script is ended. Either I will keep the virtual mic open even when the script is closed, or keep it how it is. I restart PipeWire just to reset settings to default.
5. Again, this script is very rudimentary.
