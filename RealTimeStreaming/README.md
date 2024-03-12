# RealTimeStreaming

Stream your audio or video to have a real-time call.

## Structure

run `./audio.sh` to have a normal real-time call.
run `./video.sh` to have a real-time video call.

Fill username, peername and server ip in each file according to your case.

## Notes

- `-re` keeps reading from file that is being written to.

- In the main part of the script, ffplay waits for the file to show up then the ffmpeg -re output will be piped to ffplay for it to play the video. The pipe will not have any errors before the file showing up. ffplay will simply wait not play it at the start.

- There is a couple seconds delay in both the audio and video call. The audio delay in a normal call can be tolerated but the video call delay is a bit annoying to be honest. If the delay really bugs you, you can simply use RealTimeRecording instead.