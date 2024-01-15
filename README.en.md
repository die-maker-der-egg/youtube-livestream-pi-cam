[README auf deutsch](README.md)

# YouTube Livestream with Raspberry Pi-Camera
Start a YouTube Livestream using this simple Bash-Script on a Raspberry Pi with a camera installed over the Pi-Camera-Interface.

## About this Bash-Script
This simple Bash-Script is for configuring a Youtube Livestream on a Raspberry Pi with a camera using [raspivid](https://www.raspberrypi.org/documentation/usage/camera/raspicam/raspivid.md) and [FFmpeg](https://www.ffmpeg.org/documentation.html) over Shell Commands.
It is configured to automatically start the YouTube Livestream on every system startup. You can choose to have a 300x200 pixel preview of the camera picture in the upper left area on the Raspberry Pi desktop.

## How to use it
### You need
1. Any [Raspberry Pi Computer](https://www.raspberrypi.org/products/)
2. Running [Raspberry Pi OS 11 (bullseye)](https://www.raspberrypi.org/software/operating-systems/), not compatible with 12 (bookworm) or higher
3. With a Raspberry Pi Camera-Module installed over the Pi-Camera-Interface (for example a [Pi NoIR Camera V2](https://www.raspberrypi.org/products/pi-noir-camera-v2/))
4. Stable internet connection required.
5. RTMP [YouTube Livestream](https://support.google.com/youtube/answer/2907883?hl=en#zippy=%2Csoftware-encoders%2Csoftware-encoder%2Clivestreaming-jetzt-starten%2Clivestream-planen%2Cdie-optionen-jetzt-streamen-und-liveveranstaltung-verwenden)-Key
6. No additional manual software or system-configuration after stock installation of Raspberry Pi OS needed.

## Install
1. Start the **LXTerminal** on the Raspberry Pi and type these following commands
2. **Download** package (v1.0.1): 
    - `wget https://github.com/die-maker-der-egg/youtube-livestream-pi-cam/archive/refs/tags/v1.0.1.tar.gz`
3. **Unpack** the package: 
    - `tar -xf v1.0.1.tar.gz` 
4. **Navigate** into the folder with: 
    - `cd ./youtube-livestream-pi-cam-1.0.1/`
5. **Start** Bash-Script with **sudo**: 
    - `sudo sh ./install.sh`
6. Follow the **script installation process**
7. After a restart of the Raspberry Pi OS, it should **start streaming to YouTube**.

## Uninstall
1. Navigate into the folder with:
    - `cd ./youtube-livestream-pi-cam-1.0.1/`
2. Uninstall it by running the command in the folder: 
    - `sudo sh ./uninstall.sh`

## Script installation process
1. To start the manual installation press: 
    - `y` 
    - for the **standard installation** press any other button and hit *ENTER*  
2. Type in your **RTMP YouTube Livestream-Key** (like so): 
    - `1a2b-3c4d-5e6f-7g8h-9i0j` and hit *ENTER*  
    - Repeat it
    - If it does not match, it will ask again
3. **Choose** on manual installation individually 
    - by typing:
        - `y` *(or any other button for no)* and hit *ENTER* 
            1. to turn on the **camera notification LED** 
                - **[on by standard]** 
            2. to turn on a **camera preview (300x200 pixel)** 
                - **[on by standard]** 
            3. to install **Raspberry Pi OS updates** (recommended) 
                - **[installs updates by standard]** 
            4. to **restart** your Raspberry Pi OS (recommended) 
                - **[restarts os by standard]** 

4. **Finished** 
    - After a restart, it should start streaming automatically to YouTube.
    - If the camera preview has been activated by choosing during the installation process, it should show up in the upper left area on the Raspberry Pi desktop by 300x200 pixel.

## Some useful commands
- Show livestream-service status:
    - `systemctl status my_raspivi.service`
- Stop camera streaming:
    - `sudo killall raspivid`
- Restart camera livestream:
    - `sudo systemctl daemon-reload`
    - `sudo systemctl restart my_raspivi.service`

## Troubleshooting
- If something went wrong during the installation, just run the installation-script again. It will detect the last installation-logfile (written in status.txt) and go on automatically from were it was last.
- Or just uninstall it and try installing it again.

## Source
- It is based on the **Tutorial "Livestream aus dem Nistkasten"** from Thomas Geers: https://www.thomas-geers.de/livestream-vogelhaus.html
- For more **Raspberry Pi Camera commands** visit raspberrypi.org: https://www.raspberrypi.org/documentation/raspbian/applications/camera.md
- The **raspivid** commands can be looked up on raspberrypi.org: https://www.raspberrypi.org/documentation/usage/camera/raspicam/raspivid.md
- The **FFmpeg** commands can be looked up on ffmpeg.org: https://www.ffmpeg.org/documentation.html
- To know more about **raspi-config** visit raspberrypi.org: https://www.raspberrypi.org/documentation/configuration/raspi-config.md
- How to start a YouTube Livestream: https://support.google.com/youtube/topic/9257891?hl=de&ref_topic=9257610
