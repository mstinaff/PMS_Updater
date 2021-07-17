# PMS_Updater

PMS_Updater.sh is a shell script for updating the Plex Media Server inside the FreeNAS/TrueNAS Plex plugin.

This script will search the plex.tv download site for a download link and if it is newer than the currently installed version the script will download and optionaly install the new version.


## Installation

Download the PMS_Updater.sh script in your jail:

```bash
  fetch https://github.com/mstinaff/PMS_Updater/blob/master/PMS_Updater.sh
```
## Usage

Run the script as root. The following options can be used:
```bash
   -l      Local file to install instead of latest from Plex.tv
   -d      download folder (default /tmp) Ignored if -l is used
   -a      Auto Update to newer version
   -f      Force Update even if version is not newer
   -r      Remove update packages older than current version
             Done before any update actions are taken.
   -v      Verbose
```
The script will auto determine if you installed plexpass or the normal version. It will authenticate using your servers authentication token, thus no more login/password required.

The script can also be called from a cronjob to check for updates on a regular schedule.


## Troubleshooting

Python temporarily broke in some Plex version, probably in 1.16.6.1559.
If you happen to be on this release, or any other that broke python, you
can manually download the next release and update:

```bash
cd /tmp
fetch https://downloads.plex.tv/plex-media-server-new/1.16.6.1592-b9d49bdb7/freebsd/PlexMediaServer-1.16.6.1592-b9d49bdb7-FreeBSD-amd64.tar.bz2
PMS_Updater.sh -l /tmp/PlexMediaServer-1.16.6.1592-b9d49bdb7-FreeBSD-amd64.tar.bz2
```

## Sidenotes

Thanks to @sretalla at the [FreeNAS](https://www.truenas.com/community)/[TrueNAS](https://www.truenas.com/community) forums for all the help provided.

[TrueNAS](https://www.truenas.com) (previously FreeNAS) is an excellent open-source network attached storage project based on FreeBSD that is very capable of storing even the largest media libraries

[Plex](https://www.plex.tv) is an amazing media server/client platform that can organize and stream those same media libraries.

TrueNAS (previously FreeNAS) has a plug-in architecture that makes running Plex Media Server on TrueNAS (previously FreeNAS) trivialy easy. But the available Plex Media Server plug-in is only as recent as the latest publicly available release.

To address this I have made a script that can be copied into a running Plex Media Server plug-in, and without needing anything else installed it can search the Plex.tv download site using paid PlexPass credentials and check for newer versions. If a newer version is found it can either be downloaded and held for admin approval or automatically installed to the server.