# RealTimeRecording

Communicate in real-time by recording your video!

## Structure
Start the program by running `./startVideoMessaging.sh`

- `recordVideo.sh` contains all the commands for recording a video.
- `playVideo.sh` has all the commands for playing the peer's video.
- `Sitatuions.txt` mentiones all the rules for recording and playing videos on both sides (A is your PC, B is peer's PC).

## Requirements

- You need a linux server with can be reach via SSH.
- Each person needs a user on the server by the name used in the script. (Use adduser on the server)
- Public key authentication for users connecting via SSH.
	- Create you public key by using `ssh-keygen` (Saved to `~/.ssh/id_rsa` by default)
	- Use `ssh-copy-id` to send your public key to server (Saved to `~/.ssh/authorized_keys`)
	- If you don't want to enter your password created in `ssh-keygen` each time you make ssh connection, use `ssh-add`
	- After setting up ssh for each user, set password authentication and permit root login to no in `/etc/ssh/sshd_config`
	- Just remember to have a ssh user with sudo privileges available before setting password authentication to no!
- You need to set values of the variables in all the bash scripts based on your condition. For example, entering you server ip, username, peername, etc.

## Notes

- If there is a problem with your webcam not recording or anything showing up at all you can solve this by lowering the resolution of your webcam recording. This has been done in `recordVideo.sh` by using `-vf scale=-2:360` flag in ffmpeg. Also, you can open `cheese` on your Ubuntu to solve this issue. If you don't have cheese you can install it through apt. If your video is corrupted in cheese you can probably fix it by lowering the resolution in the preferences. You should go as low as 176x144 for the video to look OK. By simply opening cheese and seeing your webcam video and closing it there should not be any more problems and the recording will show up.

- You can use any expression in the condition of if statement just make sure to put it in $()

- Process substituation ( >() ) is used to simultaneously play your video while recording and send it to the server.

- `grep` can be used in the condition of an if statment. If the match is found the status code will be zero which means it will be considered as true but if the match is not found the status code will not be zero hence false.

- `-tune zerolatency` will help a lot with the delay of recording your video.

- `-autoexit` will close ffplay when video is finished. `-an` will mute the audio.

- ffmpeg prints out so much logs. You can add `-loglevel 0` to omit everything. You can this flag in ffplay as well but just use `-stats` so you can see the timer of your video.

- In `startVideoMessaging.sh` the script will start `recordVideo.sh` and put it in the background then start `playVideo.sh` on the foreground. Using `fg %1` will bring the first job (`recordVideo.sh`) to the foreground since we need to stop the recording with Ctrl+C. Using `bg %2` will send the second job (`playVideo.sh`) to the background since we don't need it in the foreground.

- If you choose `/tmp` as ROOT_PATH make sure to run `sudo sysctl fs.protected_regular=0` or else you can NOT manipulate files even with 777 permission on the files.

- `set -m` is for allowing job management in the script.

- The trap lines will only execute on script exit (Ctrl+Z). This is a good place for clearning everything and killing jobs on the background.

- The `kill $(jobs -p)` command needs to be in single quotations. To use variables in the command you must alternate between single and double quotations and use them next to each other. Using double quotations when needing variable values and single quotations in other parts. An example of this can be seen in the script for texting.
