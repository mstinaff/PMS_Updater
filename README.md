PMS_Updater
===========
Note: I think python temporarily broke in 1.16.6.1559, if you happen to be on this release, or any other that broke python, you can manually update to get around something like this.

To get around it download the file manually and install like this,

cd /tmp

fetch https://downloads.plex.tv/plex-media-server-new/1.16.6.1592-b9d49bdb7/freebsd/PlexMediaServer-1.16.6.1592-b9d49bdb7-FreeBSD-amd64.tar.bz2

/root/PMS_Updater.sh -l /tmp/PlexMediaServer-1.16.6.1592-b9d49bdb7-FreeBSD-amd64.tar.bz2

==========

PMS_Updater.sh is a shell script for updating the Plex Media Server inside the FreeNAS Plex plugin

---

This script has been updated to work in a iocage jail in FreeNAS 11.2.  

Copy the file into the root of the directory however you like and you can then run it from within the jail to update it.  Thanks to @sretalla at the FreeNAS forums for all the help provided.

<a href="http://www.freenas.org/">FreeNAS</a> is an excellent open-source network attached storage project based on FreeBSD that is very capable of storing even the largest media libraries

<a href="http://plex.tv">Plex</a> is an amazing media server/client platform that can organize and stream those same media libraries.

FreeNAS has a plug-in architecture that makes running Plex Media Server on FreeNAS trivialy easy.  But the available Plex Media Server plug-in is only as recent as the latest publicly available release.

To address this I have made a script that can be copied into a running Plex Media Server plug-in, and without needing anything else installed it can search the Plex.tv download site using paid PlexPass credentials and check for newer versions.  If a newer version is found it can either be downloaded and held for admin approval or automatically installed to the server.

To use run PMS_Updater.sh as root. The following options can be used:

```
OPTIONS:
   -l      Local file to install instead of latest from Plex.tv
   -d      download folder (default /tmp) Ignored if -l is used
   -a      Auto Update to newer version
   -f      Force Update even if version is not newer
   -r      Remove update packages older than current version
             Done before any update actions are taken.
   -v      Verbose
```
   
Script will auto determine if you installed plexpass or normal version. It will auth using your server's auth token, no more login/password required.

The script can also be called from a cronjob to check for updates on a regular schedule.


Dependencies
===========

Should be no more dependencies.
