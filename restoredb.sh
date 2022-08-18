#!/usr/bin/env bash

## Restore KODI Database...
rm -f -R 0777 /home/kodi/
cp -v -f -r ../kodicfg/. /home/
chmod -f -R 0777 /home/kodi/

## Restore USERS Database...
rm -f -R 0777 /home/$(users | awk '{print $1}')/
cp -v -f -r ../homecfg/. /home/
chmod -f -R 0777 /home/$(users | awk '{print $1}')/
