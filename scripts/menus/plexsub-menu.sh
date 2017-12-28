
 #!/bin/bash

#check to see if /var/plexguide/dep exists - if not, install dependencies
clear

whiptail --title "Plex Information" --msgbox "If installing Plex on your OWN LOCAL Network, visit http//ip:32400/web to complete the install. If installing Plex on a remote server, visit the wiki at http://wiki.plexguide.com on how to SSH into your server to complete the setup. Visit http://ipv4:32400/web afterwards!" 13 76

function contextSwitch {
    {
    ctxt1=$(grep ctxt /proc/stat | awk '{print $2}')
        echo 50
    sleep 1
        ctxt2=$(grep ctxt /proc/stat | awk '{print $2}')
        ctxt=$(($ctxt2 - $ctxt1))
        result="Number os context switches in the last secound: $ctxt"
    echo $result > result
    } | whiptail --gauge "Getting data ..." 6 60 0
}


function userKernelMode {
    {
    raw=( $(grep "cpu " /proc/stat) )
        userfirst=$((${raw[1]} + ${raw[2]}))
        kernelfirst=${raw[3]}
    echo 50
        sleep 1
    raw=( $(grep "cpu " /proc/stat) )
        user=$(( $((${raw[1]} + ${raw[2]})) - $userfirst ))
    echo 90
        kernel=$(( ${raw[3]} - $kernelfirst ))
        sum=$(($kernel + $user))
        result="Percentage of last sekund in usermode: \
        $((( $user*100)/$sum ))% \
        \nand in kernelmode: $((($kernel*100)/$sum ))%"
    echo $result > result
    echo 100
    } | whiptail --gauge "Getting data ..." 6 60 0
}

function interupts {
    {
    ints=$(vmstat 1 2 | tail -1 | awk '{print $11}')
        result="Number of interupts in the last secound:  $ints"
    echo 100
    echo $result > result
    } | whiptail --gauge "Getting data ..." 6 60 50
}

while [ 1 ]
do
CHOICE=$(
whiptail --title "Plex Version Install" --menu "Make your choice" 10 25 3 \
    "1)" "Plex Public"   \
    "2)" "Plex Beta"  \
    "3)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plexpublic
    whiptail --title "Donation Status - Yes" --msgbox "Thank you for helping and support the Team!" 8 76     
    echo ""
    read -n 1 -s -r -p "Press any key to continue"

    "2)")
    ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags plexpass
    whiptail --title "Installing Plex Beta" --msgbox "The Beta Version of Plex has been installed!" 9 76
    echo ""
    read -n 1 -s -r -p "Press any key to continue"

    "3)")
        clear
        exit 0
        ;;
esac
done
exit
