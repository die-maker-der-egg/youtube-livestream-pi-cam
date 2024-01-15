[README in english](README.en.md)

# YouTube Livestream mit Raspberry Pi-Kamera
Starte mit diesem simplen Bash-Script einen YouTube Livestream mittels eines Raspberry Pi mit installierter Pi-Kamera am Raspberry Pi Kamera-Interface. 

## Über das Bash-Script
Dieses simple Bash-Script dient zur Konfiguration eines YouTube Livestreams auf einem Raspberry Pi mit Kamera in Verwendung von [raspivid](https://www.raspberrypi.org/documentation/usage/camera/raspicam/raspivid.md) und [FFmpeg](https://www.ffmpeg.org/documentation.html) über Shell Kommandos.
Nach jedem Systemstart, startet der Livestream der Kamera auf YouTube automatisch. Du kannst entscheiden, ob du eine Vorschau des Kamerabildes mit 300x200 Pixel im oberen linken Bereich auf dem Raspberry Pi-Desktop sehen willst.

## Verwendung
### Wird benötigt
1. Irgend ein [Raspberry Pi Computer](https://www.raspberrypi.org/products/)
2. Mit [Raspberry Pi OS 11 (bullseye)](https://www.raspberrypi.org/software/operating-systems/), nicht kompatibel mit 12 (bookworm) oder höher
3. Am Raspberry Pi Kamera-Interface angeschlossenem Raspberry Pi Kamera-Module (zum Beispiel [Pi NoIR Camera V2](https://www.raspberrypi.org/products/pi-noir-camera-v2/))
4. Eine stabile Internetverbindung
5. Dein RTMP [YouTube Livestream](https://support.google.com/youtube/answer/2907883?hl=de#zippy=%2Csoftware-encoders%2Csoftware-encoder%2Clivestreaming-jetzt-starten%2Clivestream-planen%2Cdie-optionen-jetzt-streamen-und-liveveranstaltung-verwenden)-Schlüssel
6. Keine zusätzliche manuelle Softwareinstallation oder Systemkonfiguration nach der Installation des Raspberry Pi OS nötig.

## Installation
1. Starte das **LXTerminal** auf dem Raspberry Pi und tippe die folgenden Befehle ein
2. **Herunterladen** des Pakets (v1.0.1): 
    - `wget https://github.com/die-maker-der-egg/youtube-livestream-pi-cam/archive/refs/tags/v1.0.1.tar.gz`
3. **Entpacken** des Pakets: 
    - `tar -xf v1.0.1.tar.gz` 
4. **Navigiere** in den Ordner: 
    - `cd ./youtube-livestream-pi-cam-1.0.1/`
5. **Starte** das Bash-Script mit **sudo**-Rechten: 
    - `sudo sh ./install.sh`
6. Folge dem **Bash-Script Installationsprozess**
7. Nach einem Neustart des Raspberry Pi OS, fängt es an den **Livestream auf YouTube** zu senden.

## Deinstallation
1. Navigiere in den Ordner:
    - `cd ./youtube-livestream-pi-cam-1.0.1/`
2. Deinstalliere es durch Ausführen des folgenden Bash-Script: 
    - `sudo sh ./uninstall.sh`

## Bash-Script Installationsprozess
1. Um die manuelle Installation zu starten tippe: 
    - `y` 
    - Für die **Standard Installation** drücke eine andere Taste und *ENTER* zum Bestätigen  
2. Gib dein **RTMP YouTube Livestream-Schlüssel** hier an (zum Beispiel etwa so): 
    - `1a2b-3c4d-5e6f-7g8h-9i0j` und drücke *ENTER*  
    - Wiederhole die Eingabe
    - Wenn die Eingabe nicht übereinstimmt, wiederholt sich diese Abfrage
3. **Wähle** individuell  bei der manuellen Installation
    - bei drücken der Taste:
        - `y` *(oder eine andere Taste)* und *ENTER* 
            1. zum **einschalten der Kamera Info-LED** 
                - **[Standardmäßig eingeschaltet]** 
            2. zum **einschalten der Kamera Vorschau (300x200 Pixel)** 
                - **[Standardmäßig eingeschaltet]** 
            3. zum installieren der **Raspberry Pi OS Updates** (empfohlen) 
                - **[installiert Updates Standardmäßig]** 
            4. zum **Neustarten** des Raspberry Pi OS (empfohlen) 
                - **[Neustart wird Standardmäßig ausgeführt]** 
4. **Fertig** 
    - Nach einem Neustart, fängt es automatisch an auf YouTube zu streamen.
    - Bei Auswahl der Kamera-Vorschau während der Installation, wird ein Fenster mit 300x200 Pixel auf dem Raspberry Pi-Dekstop im oberen linken Bereich angezeigt.

## Nützliche Kommandos
- Zeige livestream-service Status:
    - `systemctl status my_raspivi.service`
- Stoppe Kamera Livestream:
    - `sudo killall raspivid`
- Neustart des Kamera Livestream:
    - `sudo systemctl daemon-reload`
    - `sudo systemctl restart my_raspivi.service`

## Fehlersuche
- Sollte etwas während der Installation schiefgelaufen sein, kann das Installations-Bash-Script einfach nochmals ausgeführt werden. Es erkennt über das Installations-Logfile (status.txt) die letzte Installations-Phase und setzt an dieser Stelle wieder an.
- Oder deinstalliere es zuerst und versuche es danach noch einmal zu installieren.

## Quellen
- Es basiert auf das **Tutorial "Livestream aus dem Nistkasten"** von Thomas Geers: https://www.thomas-geers.de/livestream-vogelhaus.html
- Für mehr **Raspberry Pi Kamera Kommandos** siehe raspberrypi.org: https://www.raspberrypi.org/documentation/raspbian/applications/camera.md
- Die **raspivid** Kommandos stehen auf raspberrypi.org: https://www.raspberrypi.org/documentation/usage/camera/raspicam/raspivid.md
- The **FFmpeg** Kommandos kann auf ffmpeg.org nachgeschaut werden: https://www.ffmpeg.org/documentation.html
- Um mehr über **raspi-config** zu erfahren, siehe raspberrypi.org: https://www.raspberrypi.org/documentation/configuration/raspi-config.md
- Infos zum Starten eines YouTube Livestreams: https://support.google.com/youtube/topic/9257891?hl=de&ref_topic=9257610
