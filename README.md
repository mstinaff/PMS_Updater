PMS_Updater
===========

Shell script for updating the Plex Media Server inside the FreeNAS Plex plugin

This script will search the plex.tv download site for a download link and if it is newer than the currently installed version the script will download and optionaly install the new version.

OPTIONS:
   -u      PlexPass username
   -p      PlexPass password
   -a      Auto Update
   -v      Verbose
   
Running without the username/password or bad username/password will retrieve the latest public release rather than the latest Plex Pass release.
