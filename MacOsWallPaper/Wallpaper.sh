#!/bin/bash

LoggedinUser=$(id -un)
WallpaperFileURL="https://github.com/alourinho74/MacStuff/blob/main/MacOsWallPaper/Img/macOSWallpaper.jpg?raw=true"
WallpaperDestDir="/Library/Desktop"
WallpaperFile="Wallpaper.jpg"
logdir="/Library/IntuneAppsLogs/"
logfile="SetWallpaper.log"
logpath=$logdir/$logfile
logdirflag=1


if [ ! -d "$logdir" ]; then
  mkdir $logdir
  logdirflag=0
fi

echo  [$(date +"%d/%m/%Y %T")] - Begin > $logpath 
if [ $logdirflag -eq 0 ]; then
  echo  [$(date +"%d/%m/%Y %T")] - $logdir does not exist and was created >> $logpath
fi

#echo "Begin" > $logpath

echo  [$(date +"%d/%m/%Y %T")] - Downloading file from $WallpaperFileURL >> $logpath 
echo  [$(date +"%d/%m/%Y %T")] - Current user is $LoggedinUser >> $logpath 

echo  [$(date +"%d/%m/%Y %T")] - Copy $WallpaperFileURL to $WallpaperDestDir >> $logpath
curl -L -o $WallpaperDestDir/$WallpaperFile $WallpaperFileURL

echo  [$(date +"%d/%m/%Y %T")] - Applying new Desktop >> $logpath
osascript <<EOD
  tell application "System Events"  to tell every desktop to set picture to "$WallpaperDestDir/$WallpaperFile"
EOD




