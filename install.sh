#!/usr/bin/env bash

currentuser=$(users | awk '{print $1}')

function run-in-user-session() {
    _display_id=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    _username=$(who | grep "\(${_display_id}\)" | awk '{print $1}')
    _user_id=$(id -u "$_username")
    _environment=("DISPLAY=$_display_id" "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$_user_id/bus")
    sudo -Hu "$_username" env "${_environment[@]}" "$@"
}

function get-perl() {
echo -e '\033[1;33mInstalling \033[1;34mPerl\033[0m'
apt-get -y -qq install perl >/dev/null
apt-get -y -qq install libnet-ssleay-perl >/dev/null
apt-get -y -qq install libauthen-pam-perl >/dev/null
apt-get -y -qq install libio-pty-perl >/dev/null
}

function get-samba() {
echo -e '\033[1;33mInstalling \033[1;34mSMB File Sharing\033[0m'
apt-get -y -qq install samba --install-recommends >/dev/null
apt-get -y -qq install samba-common-bin >/dev/null
apt-get -y -qq install samba-dsdb-modules >/dev/null
apt-get -y -qq install samba-libs >/dev/null
apt-get -y -qq install samba-vfs-modules >/dev/null
apt-get -y -qq install smbclient >/dev/null
apt-get -y -qq install autofs >/dev/null
apt-get -y -qq install cifs-utils >/dev/null
apt-get -y -qq install caja-share >/dev/null
apt-get -y -qq install libsmbclient >/dev/null
apt-get -y -qq install libwbclient0 >/dev/null
apt-get -y -qq install winbind >/dev/null
apt-get -y -qq install libnss-winbind >/dev/null
mkdir -p /etc/samba
cp -f files/smb.conf /etc/samba
touch /etc/libuser.conf
chmod 0777 -R /var/lib/samba/usershares
files=$(ls -1 /var/lib/samba/usershares)
if [ "$files" != """" ]; then
  rm -f /var/lib/samba/usershares/*
fi
run-in-user-session net usershare add Shared_Media /mnt/shared_media "Media Centre" Everyone:F guest_ok=y
}

function get-kodi() {
clear
echo -e '\033[1;33mInstalling \033[1;34mKODI Media Centre\033[0m'
add-apt-repository -y ppa:team-xbmc/ppa
apt-get -y -qq update >/dev/null
apt-get -y -qq upgrade >/dev/null
apt-get -y -qq install lightdm >/dev/null
apt-get -y -qq install kodi >/dev/null
apt-get -y -qq install --install-suggests kodi >/dev/null
apt-get -y -qq install kodi-inputstream-adaptive >/dev/null
apt-get -y -qq install libbluray-bdj >/dev/null
## Creating KODI Profile for autoboot (without password)
adduser --disabled-password --disabled-login --gecos "" kodi >/dev/null
usermod -a -G cdrom,audio,render,video,plugdev,netdev,users,dialout,dip,input kodi >/dev/null
echo [Seat:*]>/etc/lightdm/lightdm.conf
echo autologin-user=kodi>>/etc/lightdm/lightdm.conf
echo autologin-session=kodi>>/etc/lightdm/lightdm.conf
## Keymap settings...
mkdir -p /home/kodi/.kodi/userdata/keymaps
touch /home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '<keymap>'>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '  <global>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '    <keyboard>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '      <backslash>noop</backslash>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '      <minus>noop</minus>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '      <plus>noop</plus>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '      <equals>noop</equals>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '      <volume_mute>noop</volume_mute>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '      <volume_down>noop</volume_down>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '      <volume_up>noop</volume_up>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '      <numpadminus>noop</numpadminus>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '      <numpadplus>noop</numpadplus>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '    </keyboard>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '  </global>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
echo -e '</keymap>'>>/home/kodi/.kodi/userdata/keymaps/keyboard.xml
## Change Audio settings to RAW for Digital Surround...
mkdir -p /home/kodi/.config/pulse
cp -f /etc/pulse/client.conf /home/kodi/.config/pulse
sed -i 's/; autospawn = yes/  autospawn = no/g' /home/kodi/.config/pulse/client.conf
}

function get-php() {
clear
echo -e '\033[1;33mInstalling \033[1;34mApache\033[0m'
apt-get -y -qq install apache2 >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mPHP 7.4\033[0m'
add-apt-repository -y ppa:ondrej/php
apt-get -y -qq update >/dev/null
apt-get -y -qq upgrade >/dev/null
apt-get -y -qq install php7.4 >/dev/null
apt-get -y -qq install php7.4-cli >/dev/null
apt-get -y -qq install php7.4-json >/dev/null
apt-get -y -qq install php7.4-common >/dev/null
apt-get -y -qq install php7.4-mysql >/dev/null
apt-get -y -qq install php7.4-zip >/dev/null
apt-get -y -qq install php7.4-gd >/dev/null
apt-get -y -qq install php7.4-mbstring >/dev/null
apt-get -y -qq install php7.4-curl >/dev/null
apt-get -y -qq install php7.4-xml >/dev/null
apt-get -y -qq install php7.4-bcmath >/dev/null
apt-get -y -qq install php7.4-opcache >/dev/null
apt-get -y -qq install php7.4-fpm >/dev/null
apt-get -y -qq install php7.4-intl >/dev/null
apt-get -y -qq install php7.4-simplexml >/dev/null
apt-get -y -qq install php7.4-bz2 >/dev/null
apt-get -y -qq install php7.4-cgi >/dev/null
apt-get -y -qq install libapache2-mod-php7.4 >/dev/null
a2enmod php7.4
update-alternatives --set php /usr/bin/php7.4
update-alternatives --set phar /usr/bin/phar7.4
update-alternatives --set phar.phar /usr/bin/phar.phar7.4
chmod -R -f 0777 /var/www/html
rm -r -f /var/www/html/*
unzip -o -q files/navphp4.45.zip -d/var/www/html
echo -e 'php_value upload_max_filesize 4.0G'>/var/www/html/.htaccess
echo -e 'php_value post_max_size 4.2G'>>/var/www/html/.htaccess
echo -e 'php_value memory_limit -1'>>/var/www/html/.htaccess
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
sed -i 's/Restart=on-abort/Restart=always/g' /lib/systemd/system/apache2.service
systemctl -q enable apache2
}

function get-krusader() {
clear
echo -e '\033[1;33mInstalling \033[1;34mKrusader Twin File Browser\033[0m'
apt-get -y -qq install krusader >/dev/null
apt-get -y -qq install libc6 >/dev/null
apt-get -y -qq install libgcc1 >/dev/null
apt-get -y -qq install zlib1g >/dev/null
apt-get -y -qq install libgcc1 >/dev/null
apt-get -y -qq install cpio >/dev/null
apt-get -y -qq install konsole >/dev/null
apt-get -y -qq install okteta >/dev/null
apt-get -y -qq install rpm >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mKrusader Twin File Browser\033[1;36m - Tools\033[0m'
apt-get -y -qq install kdiff3 >/dev/null
apt-get -y -qq install kget >/dev/null
apt-get -y -qq install kompare >/dev/null
apt-get -y -qq install krename >/dev/null
apt-get -y -qq install md5deep >/dev/null
apt-get -y -qq install kmail >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mKrusader Twin File Browser\033[1;36m - Archivers\033[0m'
apt-get -y -qq install arj >/dev/null
apt-get -y -qq install ark >/dev/null
apt-get -y -qq install bzip2 >/dev/null
apt-get -y -qq install lhasa >/dev/null
apt-get -y -qq install p7zip >/dev/null
apt-get -y -qq install rar >/dev/null
apt-get -y -qq install unace >/dev/null
apt-get -y -qq install unrar >/dev/null
apt-get -y -qq install unzip >/dev/null
apt-get -y -qq install zip >/dev/null
cp -f /usr/share/applications/org.kde.krusader.desktop /home/$currentuser/Desktop
sed -i "s/Exec=krusader -qwindowtitle %c %u/Exec=krusader -qwindowtitle %c %u --left='\/media\/$currentuser\/' --right='\/mnt\/shared_media\/'/g" /home/$currentuser/Desktop/org.kde.krusader.desktop
}

function get-games() {
echo -e '\033[1;33mInstalling \033[1;34mBackgammon Game\033[0m'
apt-get -y -qq install gnubg >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mMahjongg Game\033[0m'
apt-get -y -qq install gnome-mahjongg >/dev/null
## Create Shortcuts
mkdir -p /home/$currentuser/Desktop/Games
cp -f /usr/share/applications/gnubg.desktop /home/$currentuser/Desktop/Games
cp -f /usr/share/applications/org.gnome.Mahjongg.desktop /home/$currentuser/Desktop/Games
}

function get-conky() {
echo -e '\033[1;33mInstalling \033[1;34mConky\033[0m'
apt-get -y -qq install conky-all >/dev/null
cp -f files/conky.conf /home/$currentuser/.conkyrc
echo -e '[Desktop Entry]'>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Type=Application'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Exec=/usr/bin/conky -d'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'X-GNOME-Autostart-enabled=true'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'NoDisplay=false'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Hidden=false'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Name[en_AU]=Conky'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Comment[en_AU]=System information tool'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'X-GNOME-Autostart-Delay=5'>>/home/$currentuser/.config/autostart/conky.desktop
## HDSentinel
wget -q -O /tmp/hdsentinel.gz https://www.hdsentinel.com/hdslin/hdsentinel-019c-x64.gz
gunzip -d /tmp/hdsentinel.gz
mv -f /tmp/hdsentinel /bin
chmod 0777 /bin/hdsentinel
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /bin/hdsentinel" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /bin/hdsentinel">>/etc/sudoers
fi
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /usr/bin/lshw" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /usr/bin/lshw">>/etc/sudoers
fi
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /usr/sbin/dmidecode" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /usr/sbin/dmidecode">>/etc/sudoers
fi
}

function get-bleachbit() {
echo -e '\033[1;33mInstalling \033[1;34mBleachbit\033[0m'
apt-get -y -qq install bleachbit >/dev/null
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /usr/bin/bleachbit" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /usr/bin/bleachbit">>/etc/sudoers
fi
}

function get-duc() {
echo -e '\033[1;33mInstalling \033[1;34mDisc Usage Graph\033[0m'
apt-get -y -qq install duc >/dev/null
## Create BASH Script
echo -e '#!/bin/bash'>/bin/duc.sh
echo -e 'duc index /mnt/shared_media'>>/bin/duc.sh
echo -e 'duc gui --dark --gradient /mnt/shared_media'>>/bin/duc.sh
echo -e "rm /home/$(users | awk '{print $1}')/.duc.db">>/bin/duc.sh
## Create Desktop Icon
echo -e '[Desktop Entry]'>/home/$currentuser/Desktop/duc.desktop
echo -e 'Name=Disk Usage Chart'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Comment=Disk Usage Chart'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Exec=/bin/bash /bin/duc.sh'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Icon=gtk-harddisk'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Terminal=false'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Type=Application'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'StartupNotify=true'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'StartupWMClass=DUC'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Encoding=UTF-8'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Categories=Application;'>>/home/$currentuser/Desktop/duc.desktop
echo -e 'Name[en_AU]=Disk Usage Chart'>>/home/$currentuser/Desktop/duc.desktop
chmod +x /bin/duc.sh
}

function get-SimpleHTTPServerWithUpload() {
echo -e '\033[1;33mInstalling \033[1;34mSimple HTTP Service with Upload\033[0m'
cp -f files/SimpleHTTPServerWithUpload.py /bin
chmod +x /bin/SimpleHTTPServerWithUpload.py
## Create BASH Script
echo -e '#!/bin/bash'>/bin/SimpleHTTPServerWithUpload.sh
echo -e 'clear'>>/bin/SimpleHTTPServerWithUpload.sh
echo -e 'cd /mnt/shared_media'>>/bin/SimpleHTTPServerWithUpload.sh
echo -e 'python3 /bin/SimpleHTTPServerWithUpload.py 8080'>>/bin/SimpleHTTPServerWithUpload.sh
## Create Service
echo -e '[Unit]'>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e 'Description=Simple HTTP Server With Upload'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e '[Service]'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e 'ExecStart=/bin/SimpleHTTPServerWithUpload.sh'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e 'Restart=Always'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e '[Install]'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e 'WantedBy=multi-user.target'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
## Change Permissions
chmod +x /bin/SimpleHTTPServerWithUpload.sh
chmod 0644 /lib/systemd/system/SimpleHTTPServerWithUpload.service
systemctl -q enable SimpleHTTPServerWithUpload
}

function get-clamav() {
echo -e '\033[1;33mInstalling \033[1;34mClam Anti-Virus\033[0m'
apt-get -y -qq install clamav >/dev/null
apt-get -y -qq install clamav-daemon >/dev/null
apt-get -y -qq install clamav-freshclam >/dev/null
apt-get -y -qq install clamtk >/dev/null
}

function get-snapd() {
echo -e '\033[1;33mInstalling \033[1;34mSnapD\033[0m'
if [ -f /etc/apt/preferences.d/nosnap.pref ]; then
    rm /etc/apt/preferences.d/nosnap.pref
fi
apt-get -y -qq install snapd >/dev/null
}

function get-zoom() {
echo -e '\033[1;33mInstalling \033[1;34mZoom Video Communications\033[0m'
apt-get -y -qq install libglib2.0-0 >/dev/null
apt-get -y -qq install libgstreamer-plugins-base1.0 >/dev/null
apt-get -y -qq install libxcb-shape0 >/dev/null
apt-get -y -qq install libxcb-shm0 >/dev/null
apt-get -y -qq install libxcb-xfixes0 >/dev/null
apt-get -y -qq install libxcb-randr0 >/dev/null
apt-get -y -qq install libxcb-image0 >/dev/null
apt-get -y -qq install libfontconfig1 >/dev/null
apt-get -y -qq install libgl1-mesa-glx >/dev/null
apt-get -y -qq install libegl1-mesa >/dev/null
apt-get -y -qq install libxi6 >/dev/null
apt-get -y -qq install libsm6 >/dev/null
apt-get -y -qq install libxrender1 >/dev/null
apt-get -y -qq install libpulse0 >/dev/null
apt-get -y -qq install libxcomposite1 >/dev/null
apt-get -y -qq install libxslt1.1 >/dev/null
apt-get -y -qq install libsqlite3-0 >/dev/null
apt-get -y -qq install libxcb-keysyms1 >/dev/null
apt-get -y -qq install libxcb-xtest0 >/dev/null
apt-get -y -qq install libxcb-cursor0 >/dev/null
apt-get -y -qq install ibus >/dev/null
wget -q -O /tmp/zoom_amd64.deb https://zoom.us/client/latest/zoom_amd64.deb >/dev/null
dpkg -i /tmp/zoom_amd64.deb >/dev/null
rm -f /tmp/zoom_amd64.deb
cp -f /usr/share/applications/Zoom.desktop /home/$currentuser/Desktop
}

function fix-desktop-error() {
if ! grep -Fxq 'MimeType=application/octet-stream;' /usr/share/applications/org.kde.kdeconnect_open.desktop
then
   echo -e '\033[1;31mFixing Desktop Database...\033[0m'
   sed -i '/MimeType=/c\MimeType=application\/octet-stream;' /usr/share/applications/org.kde.kdeconnect_open.desktop
   update-desktop-database
fi
}

function get-skype() {
echo -e '\033[1;33mInstalling \033[1;34mSkype Video Commmunications\033[0m'
wget -q -O /tmp/skypeforlinux-64.deb https://repo.skype.com/latest/skypeforlinux-64.deb
dpkg -i /tmp/skypeforlinux-64.deb >/dev/null
rm -f /tmp/skypeforlinux-64.deb
cp -f /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d
cp -f /usr/share/applications/skypeforlinux.desktop /home/$currentuser/Desktop
}

function bootdrivelabel() {
   echo -e '\033[1;31mSetting Boot Hard Disc Drive Label\033[0m'
   dev=$(findmnt -t ext4 -n -o source | head -1)
   e2label $dev 'Linux Mint'
}

function desktop-settings() {
echo -e '\033[1;33mUpdating   \033[1;34mDesktop Themes And Settings...\033[0m'
# Desktop Icon Settings
run-in-user-session dconf write /org/nemo/desktop/computer-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/home-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/network-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/show-orphaned-desktop-icons "false"
run-in-user-session dconf write /org/nemo/desktop/trash-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/volumes-visible "false"
# Desktop Background Settings
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/delay 5
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/slideshow-enabled "true"
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/random-order "true"
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/image-source "'xml:///usr/share/cinnamon-background-properties/linuxmint-vera.xml'"
#Screen Saver
run-in-user-session dconf write /org/cinnamon/desktop/session/idle-delay "uint32 0"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/lock-enabled "false"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/show-notifications "false"
# Power Management
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-inactive-ac-timeout 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/button-power "'shutdown'"
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/lock-on-suspend "false"
# Themes
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme-backup "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme-backup "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme "'Adwaita-dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme-backup "'Adwaita-dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/cursor-theme "'DMZ-White'"
run-in-user-session dconf write /org/cinnamon/theme/name "'Adapta-Nokto'"
# Time / Date
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-date "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-seconds "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-use-24h "false"
}

## START INSTALLATION ##
history -c
reset
wmctrl -r :ACTIVE: -e 0,50,50,1500,800
echo -e '\ec\033[1;33mInstalling \033[1;34mCommon Utilities\033[0m'
apt-get -y -qq install software-properties-common >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mStandard Java Runtime\033[0m'
apt-get -y -qq install default-jre >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mGNOME Text Editor\033[0m'
apt-get -y -qq install gedit >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mGNU C Library\033[0m'
apt-get -y -qq install libc6 >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mDeborphan\033[0m'
apt-get -y -qq install deborphan >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mlsscsi\033[0m'
apt-get -y -qq install lsscsi >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mUseful Linux Utilities\033[0m'
apt-get -y -qq install moreutils >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mPulse Audio Volume Control\033[0m'
apt-get -y -qq install pavucontrol >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mNTFS Driver\033[0m'
apt-get -y -qq install ntfs-3g >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mNetwork Mapper\033[0m'
apt-get -y -qq install nmap >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mOpenSSL\033[0m'
apt-get -y -qq install openssl >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mlibpam-runtime\033[0m'
apt-get -y -qq install libpam-runtime >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mGDebi\033[0m'
apt-get -y -qq install gdebi >/dev/null
echo -e '\033[1;33mInstalling \033[1;34mOpenSSH\033[0m'
apt-get -y -qq install openssh-server >/dev/null

## Find first non-boot drive and create an FSTAB mount entry.
dev=$(findmnt -t fuseblk -n -o source | head -1)
uuid=$(blkid -s UUID $dev | cut -f2 -d':' | cut -c2-)
mountline=$uuid' /mnt/shared_media auto nosuid,nodev,nofail 0 0'
if ! grep -Fxq $uuid' /mnt/shared_media auto nosuid,nodev,nofail 0 0' /etc/fstab
then
	echo $mountline>>/etc/fstab
	mkdir -p /mnt/shared_media
fi

# Start Process...
get-perl
get-samba
get-kodi
get-php
get-krusader
get-games
get-conky
get-bleachbit
get-duc
get-SimpleHTTPServerWithUpload
get-clamav
get-snapd
get-zoom
fix-desktop-error
get-skype
bootdrivelabel
desktop-settings

echo "MEDIAPC" > /etc/hostname

echo -e '\033[1;33mUpdating   \033[1;34mUser Permissions\033[0m'
chmod -R 0777 /home

echo -e '\033[1;33mApplying Updates...\033[0m'
apt-get -y -qq install -f >/dev/null
dpkg --configure -a >/dev/null
apt-get -y -qq install -f >/dev/null
apt-get -y -qq clean >/dev/null
apt-get -y -qq autoclean >/dev/null
apt-get -y -qq update >/dev/null
apt-get -y -qq upgrade >/dev/null
systemctl -q daemon-reload

shutdown -r now
