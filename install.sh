#!/bin/bash



# Dieses Skript wurde mit den einfachsten Mitteln erstellt :)




### Wichtige raspivid Parameter:
cam_mode="--mode 4 -a 4 -a \"%d.%m.%Y %X\""
cam_preview="--preview 100,100,300,200"



### Farben:
rot="\033[31m"
gelb="\033[33m"
gruen="\033[32m"
blau="\033[34m"
tuerkis="\033[36m"
weiss="\033[37m"



### Cache/Pfade:
info='./INFO.txt'
status='./status.txt'
stream_start='/usr/local/bin/stream_start.sh' # './stream_start.sh'
my_raspivi='/lib/systemd/system/my_raspivi.service' # './my_raspivi.service'
cron_tab='/etc/crontab' # './crontab.txt'
fertig='./FERTIG.txt'
led='/boot/config.txt' # './config.txt'




### Starting Skript:
if [ ! -e "$status" ]
then
    ### INFOS:
    echo "${weiss}>> Infos <<"
    cat $info
    sleep 1
    ### Abfrage, ob die Installation durchgeführt werden soll + Erste Infos:
	echo "\n"
	echo "${gelb}>> Installationsskript <<"
	sleep 1
    read -p ">> Installation manuell konfigurieren? (y/n): " minstall
	sleep 1
    if [ "$minstall" = "y" ]
    then
        echo "${gruen}>>[..] Manuelle installation gestartet..."
        sleep 1
    else  
        echo "${gruen}>>[..] Standard installation gestartet..."
        sleep 1
		echo ">>[..] Kamera Info-LED wird eingeschaltet..."
		sleep 1
		echo ">>[..] Kamera-Vorschau wird eingeschaltet..."
		sleep 1
		echo ">>[..] Raspberry Pi OS Updates werden installiert..."
		sleep 1
		echo ">>[..] Nach der installation wird das System automatisch neu gestartet..."
		sleep 1
    fi
fi



### Phase01 ###
### YouTube Schlüssel:
if [ ! -e "$status" ]
then
	echo "\n"
    echo "${gruen}>> [ Phase 1 von 6 ] <<"
	sleep 1
	touch $status
	echo ">>[OK] status.txt erzeugt."
	sleep 1
### YouTube Schlüssel abfragen, speichern & Ausgeben:
	pruefe=1
	while [ $pruefe = 1 ]
	do
		echo "\n"
		echo "${weiss}>> Bitte YouTube-Livestream-Schlüssel mit Bindestrichen eingeben!"
		echo ">> z.B.: >> => 1a2b-3c4d-5e6f-7g8h"
		read -p ">> => " key1
		sleep 1
		echo ">> Bitte wiederholen:"
		read -p ">> => " key2
		sleep 1
		if [ "$key1" = "$key2" ]
		then
			echo "$key1" >> $status	
			echo "${gruen}>>[OK] YouTube-Livestream-Schlüssel gespeichert."
			pruefe=0
			sleep 1
		else
			echo "${gelb}>>[ACHTUNG] Falsche Eingabe!"
			sleep 1
		fi
	done
	sleep 1
# Status:
    echo "Phase02" >> $status # Eintrag Status: Phase02
	sleep 1
fi



### Phase02 ###
### Systemeinstellugen und Einstellungen anpassen:
var=$(sed -n "2{p;q}" $status)
if [ "$var" = "Phase02" ]
then
	echo "\n"
    echo "${gruen}>> [ Phase 2 von 6 ] <<"
	sleep 1
### Kamera-Interface aktivieren:
    cam=$(raspi-config nonint get_camera)
    if [ "$cam" = "1" ]
    then
        raspi-config nonint do_camera 0
        sleep 1
        echo ">>[OK] Kamera-Interface erfolgreich aktiviert."
        sleep 1
    else 
        echo ">>[OK] Kamera-Interface aktiv."
        sleep 1
    fi
### Kamera Info-LED:
	infoled="y"
	if [ "$minstall" = "y" ]
	then
		echo "${weiss}"
		read -p ">> Kamera Info-LED einschalten? (y/n): " infoled
		sleep 1
	fi
    if [ "$infoled" = "y" ]
    then
        echo "${gruen}>>[OK] Kamera Info-LED eingeschaltet."
        sleep 1
    else
        light=$(grep "disable_camera_led" $led)
		if [ "$light" = "" ]
		then
			echo "# Kamera Info-LED Einstellung:" >> $led
			echo "disable_camera_led=1" >> $led
			sleep 1
			echo "${gruen}>>[OK] Kamrea Info-LED deaktiviert."
			sleep 1
		else 
			echo "${gruen}>>[OK] Kamera Info-LED bereits ausgeschaltet."
			sleep 1
		fi
    fi
### Kamera-Vorschau:
	vorschau="y"
	if [ "$minstall" = "y" ]
	then
		echo "${weiss}"
		read -p ">> Kamera-Vorschau aktivieren? (y/n): " vorschau
		sleep 1
	fi
    if [ "$vorschau" = "y" ]
	then
		echo "${gruen}>>[OK] Kamera-Vorschau (300x200 pixel Fenster) aktiviert."
		sleep 1
	else
		cam_preview="--nopreview"
		echo "${gruen}>>[OK] Kamera-Vorschau deaktiviert."
		sleep 1
	fi
### Status:
    sed -i "/Phase02/d" $status
    echo "Phase02 Erfolgreich" >> $status
    sleep 1
    echo "Phase03" >> $status # Eintrag Status: Phase03
    sleep 1
fi



### Phase03 ### 
### System-Aktualisierung:
var=$(sed -n "3{p;q}" $status)
if [ "$var" = "Phase03" ]
then
	echo "\n"
    echo "${gruen}>> [ Phase 3 von 6 ] <<"
	sleep 1
### Update:
	update="y"
	if [ "$minstall" = "y" ]
	then
		echo "${weiss}"
		read -p ">> Raspberry Pi OS Updates installieren (empfohlen)? (y/n): " update
		sleep 1
	fi
	if [ "$update" = "y" ]
	then
		echo "${gruen}>>[..] Aktualisiere Raspberry Pi OS..."
		sleep 1
		apt-get update -y
		apt-get full-upgrade -y
		apt-get autoremove -y
		sleep 1
		echo ">>[OK] Aktualisierung abgeschlossen."
		sleep 1
	else  
		echo "${gelb}>>[ACHTUNG] Raspberry Pi OS Updates werden nicht installiert."
		sleep 1
	fi
### Status:
    sed -i "/Phase03/d" $status # Löscht Zeile
    echo "Phase03 Erfolgreich" >> $status
    sleep 1
    echo "Phase04" >> $status # Eintrag Status: Phase04
    sleep 1
fi



### Phase04 ###
### Notwendige Software installieren:
var=$(sed -n "4{p;q}" $status)
if [ "$var" = "Phase04" ]
then
	echo "\n"
    echo "${gruen}>> [ Phase 4 von 6 ] <<"
	sleep 1
### installieren von FFmpeg:
    echo ">>[..] Installiere FFmpeg..."
    sleep 1
    apt-get update -y
    apt-get install ffmpeg -y
    echo ">>[OK] Installation von FFmpeg abgeschlossen."
    sleep 1
### Status:
    sed -i "/Phase04/d" $status # Löscht Zeile
    echo "Phase04 Erfolgreich" >> $status
    sleep 1
    echo "Phase05" >> $status # Eintrag Status: Phase05
    sleep 1
fi



### Phase05 ###
### Livestream-Skripte erstellen:
var=$(sed -n "5{p;q}" $status)
if [ "$var" = "Phase05" ]
then
	echo "\n"
    echo "${gruen}>> [ Phase 5 von 6 ] <<"
	sleep 1
### Start-Skript erstellen:
    touch $stream_start
    sleep 1    
    echo \
	"#!bin/sh"\
	"\n\n""raspivid "\
	"--output - "\
	"$cam_preview "\
	"--timeout 0 "\
	"--framerate 30 "\
	"--bitrate 4500000 "\
	"--sharpness 50 "\
	"--contrast 20 "\
	"$cam_mode "\
	"| ffmpeg "\
	"-re "\
	"-ar 44100 "\
	"-ac 2 "\
	"-acodec pcm_s16le "\
	"-f s16le "\
	"-ac 2 "\
	"-i /dev/zero "\
	"-f h264 "\
	"-i - "\
	"-vcodec copy "\
    "-acodec aac "\
	"-ab 128k "\
	"-g 50 "\
	"-strict experimental "\
	"-f flv "\
	"rtmp://a.rtmp.youtube.com/live2/$(sed -n '1{p;q}' $status)" >> $stream_start
    echo ">>[OK] Start-Skript erstellt."
    sleep 1
### Skript ausführbar machen:
    chmod 755 $stream_start # Skript ausführbar machen!
    sleep 1
    echo ">>[OK] Skript ausführbar eingestellt."
    sleep 1
### Service-Unit erstellen:
    touch $my_raspivi
    sleep 1
    echo \
	"[Unit]"\
	"\n""SourcePath=/usr/local/bin/stream_start.sh"\
	"\n""Description=Starts the raspivid daemon"\
    "\n""DefaultDependencies=no"\
	"\n""After=network-online.target remote-fs.target rc-local.service"\
    "\n""Requires=systemd-networkd.service network-online.target"\
	"\n""Wants=network-online.target systemd-networkd-wait-online.service"\
    "\n""ConditionPathExists=/usr/local/bin/stream_start.sh"\
    "\n\n""[Service]"\
	"\n""Type=simple"\
	"\n""#User=pi"\
	"\n""RemainAfterExit=yes"\
	"\n""ExecStart=/bin/sh -c '/usr/local/bin/stream_start.sh'"\
    "\n""ExecStop=/bin/sh -c '/bin/kill -15 $(pidof raspivid); exit 0'"\
	"\n""Restart=on-failure"\
	"\n""RestartForceExitStatus=1 2 126 255"\
    "\n""IgnoreSIGPIPE=false"\
	"\n\n""[Install]"\
	"\n""WantedBy=multi-user.target" >> $my_raspivi
    sleep 1
    echo ">>[OK] Service_Unit erstellt."
    sleep 1
### Service-Unit aktivieren:
    systemctl daemon-reload
    systemctl enable my_raspivi.service
    sleep 1
    echo ">>[OK] Service_Unit aktiviert."
    sleep 1
### Cronjob zur Überprüfung der Livestreamverbindung:
    cron=$(grep "YouTube-Livestream" $cron_tab)
    if [ "$cron" = "" ]
    then
        echo "# Eintrag zur YouTube-Livestream Verbindung:" >> $cron_tab
        sleep 1
        echo "0 */1  * * * root /bin/systemctl restart my_raspivi.service > /dev/null 2>&1" >> $cron_tab
        sleep 1
        echo ">>[OK] Eintrag zur YouTube-Livestream Verbindung erfolgreich."
        sleep 1
    else
        echo ">>[OK] Eintrag zur YouTube-Livestream Verbindung bereits vorhanden."
        sleep 1
    fi
### Status:
    sed -i "/Phase05/d" $status # Löst Zeile
    echo "Phase05 Erfolgreich" >> $status
    sleep 1
    echo "Phase06" >> $status # Eintrag Status: Phase06
    sleep 1
fi



### Phase06 ###
### Fertigungshinweis erstellen:
var=$(sed -n "6{p;q}" $status)
if [ "$var" = "Phase06" ]
then
	echo "\n"
    echo "${gruen}>> [ Phase 6 von 6 ] <<"
    sleep 1
### Status:
    sed -i "/Phase06/d" $status # Löst Zeile
    echo "Phase06 Erfolgreich" >> $status
    echo "FERTIG" >> $status
	sleep 1
	touch $fertig
	sleep 1
    echo "Installation erfolgreich :D" >> $fertig
    echo "Installiert am: $(date +'%Y.%m.%d (%H:%M:%S)')" >> $fertig
	sleep 1
	echo ">>[FERTIG] Installation abgeschlossen."
    sleep 1
### Neustart:
	neustart="y"
	if [ "$minstall" = "y" ]
	then
		echo "${weiss}"
		read -p ">> Jetzt Raspberry Pi OS neustarten (empfohlen)? (y/n): " neustart
		sleep 1
	fi
    if [ "$neustart" = "y" ]
    then 
        echo "${weiss}>> reboot"
        sleep 1
        reboot
    else 
        echo "${gelb}>>[ACHTUNG] System-Neustart abgebrochen."
        sleep 1
        echo ">> Ein System-Neustarten ist erforderlich um Systemänderungen zu übernehmen."
        sleep 1
        exit
    fi
fi



### FERTIG ###
### Beenden:
var=$(sed -n "7{p;q}" $status)
if [ "$var" = "FERTIG" ]
then
    echo "${gruen}>>[FERTIG] Das Programm ist erfolgreich installiert worden."
	sleep 1
    exit
else
    echo "${rot}>>[x] Leider ist während der Installation etwas schief gelaufen..."
	sleep 1
    echo ">> Bitte einmal deinstallieren und erst danach wieder neu installieren (WICHTIG: mit sudo-Rechten)."
	sleep 1
    exit
fi