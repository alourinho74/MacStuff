#!/bin/bash
LoggedinUser=$(id -un)
WallpaperDestDir="/Library/Desktop"
WallpaperFile="Wallpaper.jpg"
logdir="/Library/IntuneAppsLogs/"
logfile="SetWallpaper-Default.log"
logpath=$logdir/$logfile
logdirflag=1

function cpwallfiles
{ 
    echo  [$(date +"%d/%m/%Y %T")] - Calculating aspec ratio >> $logpath
    aspectratio=$(echo "scale=2;($1 / $2)" | bc -l)

    case "$aspectratio" in
    1.60)
        value="16:10"
        fich="Wall_1610a.jpg?raw=true"
        ;;
    3.55)
        value="32:9"
        fich="Wall_1610a.jpg?raw=true"
        ;;
    1.77)
        value="16:09"
        fich="Wall_1609a.jpg?raw=true"
        ;;
    1.33)
        value="4:3"
        fich="Wall_43a.jpg?raw=true"
        ;;
    2.37)
        value="21:9"
        fich="Wall_1610a.jpg?raw=true"
        ;;
    2.38)
        value="21:9"
        ffich="Wall_1610a.jpg?raw=true"
        ;;
    *)
        value="Unknown"
        fich="Wall_1610a.jpg?raw=true"
        ;;
    esac

    echo  [$(date +"%d/%m/%Y %T")] - aspec ratio is $aspectratio = $value >> $logpath

    WallpaperFileURL="https://github.com/alourinho74/MacStuff/blob/main/Wallpapers/Default/$fich"
    #echo $WallpaperFileURL >> $logpath

    echo  [$(date +"%d/%m/%Y %T")] - Downloading file from $WallpaperFileURL to $WallpaperDestDir >> $logpath
    curl -L -o $WallpaperDestDir/$WallpaperFile $WallpaperFileURL

    echo  [$(date +"%d/%m/%Y %T")] - Applying new Desktop >> $logpath
    osascript <<EOD
      tell application "System Events"  to tell every desktop to set picture to "$WallpaperDestDir/$WallpaperFile"
EOD

}
function readmacresolution
{
    echo  [$(date +"%d/%m/%Y %T")] - Reading display resolution >> $logpath
    width=$(system_profiler SPDisplaysDataType |grep Resolution | awk '{print $2}') 
    height=$(system_profiler SPDisplaysDataType |grep Resolution | awk '{print $4}') 
    
    echo  [$(date +"%d/%m/%Y %T")] - width = $width >> $logpath
    echo  [$(date +"%d/%m/%Y %T")] - height = $height >> $logpath

    cpwallfiles $width $height
}
function preparelog
{
  if [ ! -d "$logdir" ]; then
    mkdir $logdir
    logdirflag=0
  fi

  echo  [$(date +"%d/%m/%Y %T")] - Begin > $logpath 
  if [ $logdirflag -eq 0 ]; then
    echo  [$(date +"%d/%m/%Y %T")] - $logdir does not exist and was created >> $logpath
  fi

  echo  [$(date +"%d/%m/%Y %T")] - Current user is $LoggedinUser >> $logpath 
}

preparelog
readmacresolution

