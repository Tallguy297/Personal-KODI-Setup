#!/usr/bin/env bash

currentuser=$(users | awk '{print $1}')

## Restore KODI Database...
echo -e '\033[1;33mKODI Media Center... \033[1;34mRestoring database\033[0m'
rm -f -r /home/kodi/
cp -f -r ../kodicfg/. /home/
echo -e '\033[1;33mKODI Media Center... \033[1;34mUpdating user permissions\033[0m'
chmod -f -R 0777 /home/kodi/
echo -e '\033[1;33mKODI Media Center... \033[1;34mUpdating user ownership\033[0m'
chown -R kodi:kodi /home/kodi

## Restore USERS Database...
echo -e '\033[1;33mUser '$currentuser'... \033[1;34mRestoring database\033[0m'
rm -f -r /home/$currentuser/
cp -f -r ../homecfg/. /home/
rm -f -r /home/$currentuser/.config/pulse
echo -e '\033[1;33mUser '$currentuser'... \033[1;34mUpdating user permissions\033[0m'
chmod -f -R 0777 /home/$currentuser/
echo -e '\033[1;33mUser '$currentuser'... \033[1;34mUpdating user ownership\033[0m'
chown -R $currentuser:$currentuser /home/$currentuser
