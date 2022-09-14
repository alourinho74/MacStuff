#!/bin/bash
#Script to Change MacOs Wallpaper
LoggedinUser=$(id -un)
scriptname="Set New Wallpaper"
alticedir="/Library/Altice/"
appsdir="/Library/Altice/Apps/"
commondir="/Library/Altice/Common/"
logdir="/Library/Altice/IntuneDTMLogs/"
wallpaperdir="/Library/Altice/Wallpaper/"
logfile="SetWallpaperDCI.log"
logpath=$logdir/$logfile
logdirflag=1

WallpaperDestDir="/Library/Altice/Wallpaper/"
WallpaperFile="Wallpaper.jpg"

function cpwallfiles
{ 
    Dolog "Calculating aspec ratio "
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

    Dolog "aspec ratio is $aspectratio = $value "
    
    WallpaperFileURL="https://github.com/alourinho74/MacStuff/blob/main/Wallpapers/Img/$fich"
	if [ ! -d "$WallpaperDestDir" ]; then
    	mkdir $WallpaperDestDir
  	fi
	
	Dolog "Downloading file from $WallpaperFileURL to $WallpaperDestDir "
    
    curl -L -o $WallpaperDestDir/$WallpaperFile $WallpaperFileURL

    Dolog "Applying new Desktop"
    #osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'"$WallpaperDestDir/$WallpaperFile"'"'
    
    ret=$?
    if [ $ret == "0" ]; then
        Dolog "Wallpaper set successfully " 
        exit 0
    else
        Dolog "Operation failed." 
        exit $ret
    fi
}
function readmacresolution
{
    Dolog "Reading display resolution"
    width=$(system_profiler SPDisplaysDataType |grep Resolution | awk '{print $2}') 
    height=$(system_profiler SPDisplaysDataType |grep Resolution | awk '{print $4}') 
    
    Dolog "width = $width"
    Dolog "height = $height "
    
    cpwallfiles $width $height
}
function preparelog
{
    alticedirflag=1
    if [ ! -d "$alticedir" ]; then
        mkdir $alticedir
        alticedirflag=0
    fi
 
    if [ ! -d "$logdir" ]; then
        mkdir $logdir
        logdirflag=0
    fi
 
    echo  [$(date +"%d/%m/%Y %T")] - Begin $scriptname > $logpath
    if [ $alticedirflag -eq 0 ]; then
        Dolog "$alticedir does not exist and was created"
    fi
 
    if [ $logdirflag -eq 0 ]; then
        Dolog "$logdir does not exist and was created"
    fi
 
    if [ ! -d "$appsdir" ]; then
        mkdir $appsdir
        Dolog "$appsdir does not exist and was created"
    fi
 
    if [ ! -d "$commondir" ]; then
        mkdir $commondir
        Dolog "$commondir does not exist and was created"
    fi
 
    if [ ! -d "$wallpaperdir" ]; then
        mkdir $wallpaperdir
        Dolog "$wallpaperdir does not exist and was created"
    fi
}

function Dolog
{
    printf "[$(date +"%d/%m/%Y %T")] - $1\n" >> $logpath
}

preparelog
readmacresolution

