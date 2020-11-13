#!/bin/bash
reset

function run-in-user-session() {
    _display_id=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    _username=$(who | grep "\(${_display_id}\)" | awk '{print $1}')
    _user_id=$(id -u "$_username")
    _environment=("DISPLAY=$_display_id" "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$_user_id/bus")
    sudo -Hu "$_username" env "${_environment[@]}" "$@"
}

function apt-update() {
     apt-get -y install -f
     dpkg --configure -a
     apt-get -y install -f
     apt-get -y clean
     apt-get -y autoclean
     apt-get -y update
}

add-apt-repository -y ppa:team-xbmc/ppa
add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:ondrej/apache2
add-apt-repository -y ppa:peterlevi/ppa

apt-update

apt-get -y install default-jre
apt-get -y install clamav
apt-get -y install clamav-daemon
apt-get -y install clamav-freshclam
apt-get -y install clamtk
apt-get -y install moreutils
apt-get -y install apache2
apt-get -y install libapache2-mod-php7.4
apt-get -y install libxcb-xtest0
apt-get -y install ibus
apt-get -y install libncursesw5-dev
apt-get -y install libcairo2-dev
apt-get -y install libpango1.0-dev
apt-get -y install build-essential
apt-get -y install duc
apt-get -y install php7.4
apt-get -y install php7.4-{bcmath,bz2,cgi,cli,common,curl,fpm,gd,intl,json,mbstring,mysql,xml,zip}
apt-get -y install perl
apt-get -y install libnet-ssleay-perl
apt-get -y install openssl
apt-get -y install libauthen-pam-perl
apt-get -y install libpam-runtime
apt-get -y install libio-pty-perl
apt-get -y install python
apt-get -y install gdebi
apt-get -y install gedit
apt-get -y install software-properties-common
apt-get -y install kodi
apt-get -y install kodi-inputstream-adaptive
apt-get -y install libbluray-bdj
apt-get -y install --install-suggests kodi
apt-get -y install libsmbclient
apt-get -y install libwbclient0
apt-get -y install python-dnspython
apt-get -y install python3-smbc
apt-get -y install samba --install-recommends
apt-get -y install samba-{common-bin,dsdb-modules,libs,vfs-modules}
apt-get -y install smbclient
apt-get -y install caja-share
apt-get -y install winbind
apt-get -y install libnss-winbind
apt-get -y install openssh-server
apt-get -y install ntfs-3g
apt-get -y install lightdm
apt-get -y install conky-all
apt-get -y install lsscsi
apt-get -y install krusader
apt-get -y install kdiff3
apt-get -y install kompare
apt-get -y install krename
apt-get -y install konsole
apt-get -y install lhasa
apt-get -y install arj
apt-get -y install unace
apt-get -y install rar
apt-get -y install rpm
apt-get -y install kget
apt-get -y install kde-cli-tools
apt-get -y install nfs-common
apt-get -y install cifs-utils
apt-get -y install autofs
apt-get -y install nfs-kernel-server
apt-get -y install htop
apt-get -y install nmap
apt-get -y install bleachbit
apt-get -y install dconf-editor
apt-get -y install deborphan
apt-get -y install gparted
apt-get -y install adwaita-icon-theme-full
apt-get -y install variety
apt-get -y install adapta-gtk-theme
apt-get -y install gnubg
apt-get -y install gnome-mahjongg

wget -O /tmp/skypeforlinux-64.deb https://repo.skype.com/latest/skypeforlinux-64.deb
dpkg -i /tmp/skypeforlinux-64.deb
rm -f -v /tmp/skypeforlinux-64.deb
apt-update

wget -O /tmp/zoom_amd64.deb https://zoom.us/client/latest/zoom_amd64.deb
dpkg -i /tmp/zoom_amd64.deb
rm -f -v /tmp/zoom_amd64.deb
apt-update

pushd /root
echo "deb http://download.webmin.com/download/repository sarge contrib">/etc/apt/sources.list.d/webmin.list
wget -O /tmp/tmpkey http://www.webmin.com/jcameron-key.asc
apt-key add /tmp/tmpkey
rm -f -v /tmp/tmpkey
apt-update
apt-get -y install apt-transport-https
apt-get -y install webmin
/usr/share/webmin/changepass.pl /etc/webmin root ''
sed -i 's/port=10000/port=8000/g' /etc/webmin/miniserv.conf
sed -i 's/listen=10000/listen=8000/g' /etc/webmin/miniserv.conf
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
popd

cp -v -f files/hdsentinel /bin
chmod -v 0777 /bin/hdsentinel
mkdir -p -v /var/www/html
cp -v -f files/phpFileManager.php /var/www/html/index.php
chmod -v -R 0777 /var/www/html
rm -f -v /var/www/html/index.html
echo -e 'php_value upload_max_filesize 4.0G'>/var/www/html/.htaccess
echo -e 'php_value post_max_size 4.2G'>>/var/www/html/.htaccess
echo -e 'php_value memory_limit -1'>>/var/www/html/.htaccess
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

cp -v -f files/SimpleHTTPServerWithUpload.py /bin
cp -v -f files/SimpleHTTPServerWithUpload.sh /bin
chmod -v +x /bin/SimpleHTTPServerWithUpload.py
chmod -v +x /bin/SimpleHTTPServerWithUpload.sh
cp -v -f files/SimpleHTTPServerWithUpload.service /lib/systemd/system
chmod -v 0644 /lib/systemd/system/SimpleHTTPServerWithUpload.service

mkdir -p -v /etc/samba
cp -v -f files/smb.conf /etc/samba
touch /etc/libuser.conf

if id -u kodi > /dev/null 2>&1; then
echo -e "KODI user already exists, deleting profile...\n"
touch /var/mail/kodi
userdel -f -r kodi
fi
echo -e "Creating new KODI profile..."
adduser --disabled-password --disabled-login --gecos "" kodi
usermod -a -G cdrom,audio,video,plugdev,netdev,users,dialout,dip,input kodi
echo [Seat:*]>/etc/lightdm/lightdm.conf
echo autologin-user=kodi>>/etc/lightdm/lightdm.conf
echo autologin-session=kodi>>/etc/lightdm/lightdm.conf

mkdir -p -v /home/kodi/.kodi/userdata/keymaps
cp -v -f files/keyboard.xml /home/kodi/.kodi/userdata/keymaps

mkdir -p -v /home/kodi/.config/pulse
cp -v -f /etc/pulse/client.conf /home/kodi/.config/pulse
sed -i 's/; autospawn = yes/  autospawn = no/g' /home/kodi/.config/pulse/client.conf

sed -i 's/Restart=on-abort/Restart=always/g' /lib/systemd/system/apache2.service

echo -e '/mnt/sdb1 *(rw,async,no_root_squash,no_subtree_check)'>/etc/exports

if ! grep -Fxq '/mnt/WORKGROUP /etc/auto.sambashares --timeout=30 --ghost' /etc/auto.master
then
	echo -e '/mnt/WORKGROUP /etc/auto.sambashares --timeout=30 --ghost'>>/etc/auto.master
	echo -e 'Drive_D -fstype=cifs,rw,username=guest,password=,uid=1000,iocharset=utf8 ://192.168.0.2/Drive_D'>/etc/auto.sambashares
	echo -e 'Drive_E -fstype=cifs,rw,username=guest,password=,uid=1000,iocharset=utf8 ://192.168.0.2/Drive_E'>>/etc/auto.sambashares
fi

echo "MEDIAPC" > /etc/hostname

LOGGEDINUSER=$(users)

mkdir -p -v /home/$LOGGEDINUSER/Desktop/Games
cp -v -f /usr/share/applications/skypeforlinux.desktop /home/$LOGGEDINUSER/Desktop
cp -v -f /usr/share/applications/Zoom.desktop /home/$LOGGEDINUSER/Desktop
cp -v -f /usr/share/applications/org.kde.krusader.desktop /home/$LOGGEDINUSER/Desktop
cp -v -f /usr/share/applications/gnubg.desktop /home/$LOGGEDINUSER/Desktop/Games
cp -v -f /usr/share/applications/org.gnome.Mahjongg.desktop /home/$LOGGEDINUSER/Desktop/Games
cp -v -f files/duc.desktop /home/$LOGGEDINUSER/Desktop
cp -v -f files/duc.sh /bin
cp -v -f files/duc.png /bin

chmod -v -R 0777 /home/$LOGGEDINUSER 

cp -v -f 'files/Bleachbit.desktop' /home/$LOGGEDINUSER/.config/autostart
cp -v -f 'files/Conky.desktop' /home/$LOGGEDINUSER/.config/autostart

sed -i "s/Exec=krusader -qwindowtitle %c %u/Exec=krusader -qwindowtitle %c %u --left='\/media\/$LOGGEDINUSER\/' --right='\/mnt\/sdb1'/g" /home/$LOGGEDINUSER/Desktop/org.kde.krusader.desktop

cp -v -f files/conky.conf /home/$LOGGEDINUSER/.conkyrc
chmod -v 0777 -R /home/$LOGGEDINUSER/.conkyrc

if ! grep -Fxq $LOGGEDINUSER" ALL=NOPASSWD: /bin/hdsentinel" /etc/sudoers
then
    echo $LOGGEDINUSER" ALL=NOPASSWD: /bin/hdsentinel">>/etc/sudoers
fi

if ! grep -Fxq $LOGGEDINUSER" ALL=NOPASSWD: /usr/bin/lshw" /etc/sudoers
then
    echo $LOGGEDINUSER" ALL=NOPASSWD: /usr/bin/lshw">>/etc/sudoers
fi

if ! grep -Fxq $LOGGEDINUSER" ALL=NOPASSWD: /usr/sbin/dmidecode" /etc/sudoers
then
    echo $LOGGEDINUSER" ALL=NOPASSWD: /usr/sbin/dmidecode">>/etc/sudoers
fi

if ! grep -Fxq $LOGGEDINUSER" ALL=NOPASSWD: /usr/bin/bleachbit" /etc/sudoers
then
    echo $LOGGEDINUSER" ALL=NOPASSWD: /usr/bin/bleachbit">>/etc/sudoers
fi

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
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/image-source "'xml:///usr/share/cinnamon-background-properties/linuxmint-ulyana.xml'"

#Screen Saver
run-in-user-session dconf write /org/cinnamon/desktop/session/idle-delay "uint32 0"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/lock-enabled "false"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/show-notifications "false"
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/lock-on-suspend "false"

# Power Management
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-inactive-ac-timeout 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/button-power "'shutdown'"

# Themes
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme-backup "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme-backup "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme "'Adapta-Nokto'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme-backup "'Adapta-Nokto'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/cursor-theme "'DMZ-White'"
run-in-user-session dconf write /org/cinnamon/theme/name "'Adapta-Nokto'"

#Time / Date
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-date "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-seconds "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-use-24h "false"

#Update All User Settings
run-in-user-session dconf update

apt-update

a2enmod php7.4
a2dismod mpm_event
a2enmod php7.4
systemctl daemon-reload
systemctl enable apache2
systemctl enable SimpleHTTPServerWithUpload
systemctl enable webmin

mkdir -p -v /home/kodi/.kodi/temp
chmod -v -R 0777 /home/kodi

shutdown -r now
