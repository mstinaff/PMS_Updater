#!/bin/sh
# Argument = -u username -p password -a -v

URL="https://plex.tv/downloads?channel=plexpass"
DOWNLOADPATH="/tmp"
PMSPARENTPATH="/usr/pbi/plexmediaserver-amd64/share"
PMSLIVEFOLDER="plexmediaserver"
PMSBAKFOLDER="plexmediaserver.bak"
PMSPATTERN="http.*-freebsd-amd64.tar.bz2"
AUTOUPDATE=0
VERBOSE=0

usage()
{
cat << EOF
usage: $0 options

This script will search the plex.tv download site for a download link
and if it is newer that the currently installed version the script will
download and optionaly install the new version.

OPTIONS:
   -u      PlexPass username
   -p      PlexPass password
   -a      Auto Update
   -v      Verbose
EOF
}

while getopts x."u:p:av" OPTION
do
     case $OPTION in
         u) USERNAME=$OPTARG ;;
         p) PASSWORD=$OPTARG ;;
         a) AUTOUPDATE=1 ;;
         v) VERBOSE=1 ;;
         ?) usage; exit ;;
     esac
done

if [ $VERBOSE = 1 ]; then echo -n Fetching $URL .....; fi
wget --quiet --http-user="$USERNAME" --http-password="$PASSWORD" --auth-no-challenge --no-check-certificate --output-document="/tmp/plex.update" "$URL"
if [ $? -ne 0 ]; then
    # Error on the wget of the page.  Error and Exit
    echo Error downloading $URL
    exit 1
else
    if [ $VERBOSE = 1 ]; then echo Done.; fi
    if [ $VERBOSE = 1 ]; then echo -n Searching $URL for $PMSPATTERN .....; fi
    DOWNLOADURL=`grep -o $PMSPATTERN /tmp/plex.update`
    if [ "x$DOWNLOADURL" = "x" ]; then
        # DOWNLOADURL is zero length, i.e. nothing matched PMSPATTERN. Error and exit
        echo Could not find a $PMSPATTERN PlexMediaServer-[version]-freebsd-amd64.tar.bz2 download link on page $URL
        exit 1
    else
        if [ $VERBOSE = 1 ]; then echo Done.; fi
        if [ $VERBOSE = 1 ]; then echo Found download link $DOWNLOADURL; fi
        # Extract the filename to be downloaded
        DOWNLOADFILE=`basename $DOWNLOADURL`
# extract version and check if newer
        if [ ! -e $DOWNLOADPATH/$DOWNLOADFILE ]; then
            # If it hasn't already been downloaded, get it (check for failed prev download?)
            if [ $VERBOSE = 1 ]; then echo -n Downloading $DOWNLOADFILE .....; fi
            wget -qP $DOWNLOADPATH $DOWNLOADURL
            if [ $? -ne 0 ]; then
                #  Something went wrong with the download. (should clean up) error and exit
                echo Error downloading $DOWNLOADURL
                rm -f $DOWNLOADPATH/$DOWNLOADFILE
                exit 1
            else
                if [ $VERBOSE = 1 ]; then echo Done.; fi
                if [ $AUTOUPDATE = 1 ]; then
                  if [ $VERBOSE = 1 ]; then echo Auto-Update enabled.; fi
                  if [ $VERBOSE = 1 ]; then echo -n Verifying $DOWNLOADFILE .....; fi
                  bzip2 -t $DOWNLOADPATH/$DOWNLOADFILE
                  if [ $? -ne 0 ]; then
                      echo $DOWNLOADFILE is not a valid archive, cannot update with this file.
                  else
                      if [ $VERBOSE = 1 ]; then echo Done; fi
                      if [ $VERBOSE = 1 ]; then echo -n Removing previous PMS Backup .....; fi
                      rm -rf $PMSPARENTPATH/$PMSBAKFOLDER
                      if [ $VERBOSE = 1 ]; then echo Done.; fi
                      if [ $VERBOSE = 1 ]; then echo -n Stopping Plex Media Server .....; fi
                      service plexmediaserver stop
                      if [ $VERBOSE = 1 ]; then echo Done.; fi
                      if [ $VERBOSE = 1 ]; then echo -n Moving current Plex Media Server to backup location .....; fi
                      mv $PMSPARENTPATH/$PMSLIVEFOLDER/ $PMSPARENTPATH/$PMSBAKFOLDER/
                      if [ $VERBOSE = 1 ]; then echo Done.; fi
                      if [ $VERBOSE = 1 ]; then echo -n Extracting $DOWNLOADFILE .....; fi
                      mkdir $PMSPARENTPATH/$PMSLIVEFOLDER/
                      tar -xj --strip-components 1 --file $DOWNLOADPATH/$DOWNLOADFILE --directory $PMSPARENTPATH/$PMSLIVEFOLDER/
                      if [ $? -ne 0 ]; then
                          rm -rf $PMSPARENTPATH/$PMSLIVEFOLDER/
                          mv $PMSPARENTPATH/$PMSBAKFOLDER/ $PMSPARENTPATH/$PMSLIVEFOLDER/
                          echo Error exctracting $DOWNLOADFILE. Rolling back to previous version.
                      else
                          if [ $VERBOSE = 1 ]; then echo Done.; fi
                      fi
                      if [ $VERBOSE = 1 ]; then echo -n Starting Plex Media Server .....; fi
                      service plexmediaserver start
                      if [ $VERBOSE = 1 ]; then echo Done.; fi
                  fi
                fi
            fi
        fi
    fi
fi
