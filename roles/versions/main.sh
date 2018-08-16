#!/bin/bash
#
# [Ansible Role]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & Deiteq
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
program_selection="default"

while [ "$program_selection" != "exit" ]; do

ansible-playbook /opt/plexguide/pg.yml --tags versions
program=$(cat /tmp/program_selection)

running=$(cat /opt/plexguide/roles/versions/scripts/ver.list | grep $program -oP )
if [ "$program" == "$running" ]; then

  if [ "$program" == "edge" ]; then
    rm -r /opt/plexguide2 1>/dev/null 2>&1
    ansible-playbook /opt/plexguide/pg.yml --tags pgedge
    rm -r /opt/plexguide 1>/dev/null 2>&1
    mv /opt/plexguide2 /opt/plexguide
    touch /var/plexguide/ask.yes 1>/dev/null 2>&1
    echo "INFO - Selected: Upgrade to PG EDGE" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    echo ""
    read -n 1 -s -r -p "Press any key to continue"
    bash /opt/plexguide/roles/ending/ending.sh
  else
    touch /var/plexguide/ask.yes 1>/dev/null 2>&1
    version="$program"

    file="/var/plexguide/ask.yes"
    if [ -e "$file" ]; then
      touch /var/plexguide/ask.yes 1>/dev/null 2>&1
        if ! dialog --stdout --title "Version User Confirmation" \
           --backtitle "Visit https://PlexGuide.com - Automations Made Simple" \
           --yesno "\nDo Want to Install: Version - $version?" 7 50; then
          dialog --title "PG Update Status" --msgbox "\nExiting! User selected to NOT Install!" 0 0
          clear
          echo 'INFO - Selected Not To Upgrade PG' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

          sudo bash /opt/plexguide/roles/ending/ending.sh
          exit 0
        else
          clear
        fi
    else
      clear
    fi

    rm -rf /opt/plexguide 2>/dev/null
    wget https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server/archive/$version.zip -P /tmp
    unzip /tmp/$version.zip -d /opt/
    mv /opt/PlexG* /opt/plexguide
    bash /opt/plexg*/sc*/ins*
    rm -r /tmp/$version.zip
    touch /var/plexguide/ask.yes 1>/dev/null 2>&1

    echo "INFO - Selected: Upgrade to PG $version" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
    exit
  fi


  dialog --title "--- NOTE ---" --msgbox "\nPG $program Deployed!\n\nProcess Complete!" 0 0
  clear
else
  if [ "$program" == "exit" ];then
    exit
  else
    dialog --title "--- NOTE ---" --msgbox "\nPG $program does not exist!\n\nRestarting!" 0 0
    clear
    program=default
  fi
fi

if [ "$menu" == "update" ]; then
  echo 'INFO - Selected: PG Upgrades Menu Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
  bash /opt/plexguide/menus/version/main.sh
  exit
fi

echo 'INFO - Looping: PG Application Suite Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done

echo 'INFO - Selected: Exiting Application Suite Interface' > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
exit