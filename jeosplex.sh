#!/bin/su root
# This script is intended to be run as root

# get everything needed
apt install -y unattended-upgrades flatpak weston xwayland

# add flathub.org as repository for flatpaks
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# install plex player for HTPCs
flatpak install -y tv.plex.PlexHTPC

# create weston config file for user plex
mkdir /home/plex/.config
touch /home/plex/.config/weston.ini
chown plex:plex /home/plex/.config/weston.ini
# weston starts in kiosk mode, uses xwayland to run plex as an X-app and runs a start script
# keyboard layout is changed to German (optional)
echo "[core]
shell=kiosk-shell.so
xwayland=true

[keyboard]
keymap_layout=de

[autolaunch]
path=/home/plex/start-plex.sh" > /home/plex/.config/weston.ini

# create a script that starts plex player and shuts down when quitting
echo "#!/bin/sh
flatpak run tv.plex.PlexHTPC && /usr/sbin/shutdown now" > /home/plex/start-plex.sh
# make start script executable
chmod +x /home/plex/start-plex.sh
# start weston at startup
echo "weston" >> /home/plex/.bashrc

# create a systemd service that always logs in user plex automatically on tty1
mkdir -p /etc/systemd/system/getty@tty1.service.d
echo "[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin plex --noclear %I 38400 linux" > /etc/systemd/system/getty@tty1.service.d/override.conf

# activate unattended upgrades (automatic os security updates)
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades

# deactivate grub menu for faster boot
sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
update-grub

# done
reboot
