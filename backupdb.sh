#!/usr/bin/env bash

currentuser=$(users | awk '{print $1}')

## Backup KODI Database...
echo -e '\033[1;33mKODI Media Center... \033[1;34mBacking Up database\033[0m'
mkdir -p ../kodicfg
cp -f -r /home/kodi/ ../kodicfg/

## Backup USER Database...
echo -e '\033[1;33mUser '$currentuser'... \033[1;34mBacking Up database\033[0m'
mkdir -p ../homecfg
cp -f -r /home/$currentuser/ ../homecfg/
