# Jeosplex
## Just enough Operating System for Plex

Shell script that turns a Debian testing (bookworm) minimal install into a Plex HTPC appliance.
Will not run on Debian 11 (bullseye) because of Weston version, only tested on testing.

## Instructions
* Download Debian testing netinstall: https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso
* Boot and create user plex during install
* uncheck all options during software selection
* after reboot run script as root
