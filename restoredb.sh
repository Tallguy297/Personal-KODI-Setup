#!/usr/bin/env bash

## Restore KODI Database...
rm -f -r /home/kodi/
cp -v -f -r ../kodicfg/. /home/
chmod -f -R 0777 /home/kodi/

## Restore USERS Database...
rm -f -r /home/$(users | awk '{print $1}')/
cp -v -f -r ../homecfg/. /home/
rm -f -r /home/$(users | awk '{print $1}')/.config/pulse
chmod -f -R 0777 /home/$(users | awk '{print $1}')/
