#!/usr/bin/env bash

## Backup KODI Database...
mkdir -p ../kodicfg
cp -v -f -r /home/kodi/ ../kodicfg/

## Backup USER Database...
mkdir -p ../homecfg
cp -v -f -r /home/$(users | awk '{print $1}')/ ../homecfg/
