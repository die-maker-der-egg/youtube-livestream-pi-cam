#!/bin/bash



# Dieses Skript wurde mit den einfachsten Mitteln erstellt :)



### Farben:
rot="\033[31m"
gelb="\033[33m"
gruen="\033[32m"
blau="\033[34m"
tuerkis="\033[36m"
weiss="\033[37m"



### Cache/Pfade:
info='./info.txt'
status='./status.txt'
stream_start='/usr/local/bin/stream_start.sh' # './stream_start.sh'
my_raspivi='/lib/systemd/system/my_raspivi.service' # './my_raspivi.service'
cron_tab='/etc/crontab' # './crontab.txt'
fertig='./FERTIG.txt'
led='/boot/config.txt' # './config.txt'



### Abfrage, ob die Installation durchgeführt werden soll:
echo -n "${gelb}"
read -p ">> Wollen Sie die Deinstallation des YouTube-Livestreams ausführen? (y/n): " uninstall 
sleep 1
if [ $uninstall = "y" ]
then
    echo "${gruen}>>[..] Deinstallation gestartet..."
    sleep 1
else
    echo "${rot}>>[x] Deinstallation abgebrochen."
    sleep 1
    exit  
fi


###################################################
### Deinstallieren & Zurücksetzten der Software ###
###################################################

### Laufende Software beenden:
echo ">>[..] Stoppe laufende Software..."
killall raspivid
systemctl disable my_raspivi.service
systemctl daemon-reload
sleep 1
echo ">>[OK] Software gestoppt."
sleep 1



### Fertigungshinweis entfernen:
if [ -e "$fertig" ]
then
    rm $fertig
    sleep 1
    echo ">>[OK] Fertigungshinweis entfernt."
    sleep 1
else
    echo "${gruen}>>[OK] Fertigungshinweis: ok"
    sleep 1
fi



### Statusinformationen entfernen:
if [ -e "$status" ]
then
    rm $status
    sleep 1
    echo ">>[OK] Löschen von Statusinformation erfolgreich."
    sleep 1
else 
    echo "${gruen}>>[OK] Statusinformationen: ok"
    sleep 1
fi



### Cronjob zurücksetzen:
cronz1=$(grep "Youtube-Livestream" $cron_tab)
cronz2=$(grep "my_raspivi.service" $cron_tab)
if [ "$cronz1" != "" -a "$cronz2" != "" ]
then
    sed -i "/Youtube-Livestream/d" $cron_tab
    sleep 1
    sed -i "/my_raspivi.service/d" $cron_tab
    echo ">>[OK] Cronjob zurückgesetzt."
    sleep 1
else
    echo "${gruen}>>[OK] Cronjob: ok"
    sleep 1
fi



### Kamera LED zurücksetzen:
lightz1=$(grep "Info-LED" $led)
lightz2=$(grep "disable_camera_led=" $led)
if [ "$lightz1" != "" -a "$lightz2" != "" ] 
then
    sed -i "/Info-LED/d" $led
    sleep 1
    sed -i "/disable_camera_led=/d" $led
    echo "${gruen}>>[OK] Kamera LED Einstellung zurückgesetzt."
    sleep 1
else
    echo "${gruen}>>[OK] Kamera LED: ok"
    sleep 1
fi



### Kamera Einstellung zurücksetzen:
cam=$(raspi-config nonint get_camera)
if [ "$cam" = "0" ]
then 
    raspi-config nonint do_camera 1
    sleep 1
    echo "${gruen}>>[OK] Kamera erfolgreich deaktiviert."
    sleep 1
else 
    echo "${gruen}>>[OK] Kamera: ok"
    sleep 1
fi


#######################
### Skripte Löschen ###
#######################

### Start-Skript entfernen:
if [ -e "$stream_start" ]
then
    rm $stream_start
    sleep 1
    echo "${gruen}>>[OK] Start-Skript entfernt."
    sleep 1  
else
    echo "${gruen}>>[OK] Start-Skript: ok"
    sleep 1
fi



### Service-Unit entfernen:
if [ -e "$my_raspivi" ]
then
    rm $my_raspivi
    sleep 1
    echo "${gruen}>>[OK] Service-Unit entfernt."
    sleep 1
else
    echo "${gruen}>>[OK] Service-Unit: ok"
    sleep 1
fi



### Fertig ###
if [ ! -e "$status" ]
then
    echo "${gruen}>>[FERTIG] Deinstallation abgeschlossen."
	sleep 1
### Neustart:
	echo "${weiss}"
    read -p ">> Jetzt neustarten und alle Änderungen übernehmen? (y/n): " neustart
    if [ "$neustart" = "y" ]
    then 
        echo "${weiss}>> reboot"
        sleep 1
        reboot
    else 
        echo "${gelb}>>[ACHTUNG] System-Neustart abgebrochen."
        sleep 1
        echo ">> Ein System-Neustart ist erforderlich um Systemänderungen zu übernehmen."
        sleep 1
        exit
    fi
    exit
else
    echo "${rot}>>[x] Deinstallation Fehlgeschlagen... :/"
	sleep 1
    echo ">> WICHTIG: sudo-Rechte verwenden, z.B.: sudo sh ./uninstall.sh"
    sleep 1
    exit
fi
