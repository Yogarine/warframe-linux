#!/bin/bash

# Change to your preferred installation directory
GAMEDIR="/Users/${USER}/Warframe"

echo "*************************************************"
echo "Making sure wine and winetricks are installed."
echo "*************************************************"

brew install wine winetricks

echo "*************************************************"
echo "Creating wine prefix and performing winetricks."
echo "*************************************************"

WINEDEBUG=-all WINEARCH=win32 WINEPREFIX=$GAMEDIR winetricks -q vcrun2015 xact xinput winxp

echo "*************************************************"
echo "Creating warframe directories."
echo "*************************************************"
mkdir -p ${GAMEDIR}/drive_c/Program\ Files/Warframe/
mkdir -p ${GAMEDIR}/drive_c/users/${USER}/Local\ Settings/Application\ Data/Warframe

echo "*************************************************"
echo "Copying warframe files."
echo "*************************************************"
cp -R * ${GAMEDIR}/drive_c/Program\ Files/Warframe/ 

cd ${GAMEDIR}/drive_c/Program\ Files/Warframe/
chmod a+x wget.exe
mv EE.cfg ${GAMEDIR}/drive_c/users/${USER}/Local\ Settings/Application\ Data/Warframe/EE.cfg

echo "*************************************************"
echo "Applying warframe wine prefix registry settings."
echo "*************************************************"
sed -i .bak "s/%USERNAME%/"$USER"/g" wf.reg
WINEDEBUG=-all WINEARCH=win32 WINEPREFIX=$GAMEDIR wine regedit /S wf.reg


echo "*************************************************"
echo "The next few steps will prompt you for shortcut creations. If root is required, please enter your root password when prompted."
echo "*************************************************"

echo "*************************************************"
echo "Creating warframe shell script"
echo "This script uses __GL_SHADER_DISK_CACHE=1 and __GL_SHADER_DISK_CACHE_PATH=${GAMEDIR}"
echo "If you are not installing the game on an SSD hard drive, please remove these two environment variables from /usr/local/bin/warframe"
echo "You can do this via sudo nano /usr/local/bin/warframe"
echo "*************************************************"

echo "#!/bin/bash" > warframe.sh

echo "export PULSE_LATENCY_MSEC=60" >> warframe.sh
echo "export __GL_THREADED_OPTIMIZATIONS=1" >> warframe.sh

echo "cd ${GAMEDIR}/drive_c/Program\ Files/Warframe/" >> warframe.sh
echo "WINEARCH=win32 WINEPREFIX=$GAMEDIR WINEDEBUG=-all wine cmd /C Warframe-Launcher.bat" >> warframe.sh

chmod a+x warframe.sh
sudo mkdir -p /usr/local/bin && \
sudo cp ${GAMEDIR}/drive_c/Program\ Files/Warframe/warframe.sh /usr/local/bin/warframe


#read -p "Would you like a menu shortcut? y/n" -n 1 -r
#echo    # (optional) move to a new line
#if [[ $REPLY =~ ^[Yy]$ ]]
#then
#
#	echo "*************************************************"
#	echo "Creating warframe application menu shortcut."
#	echo "*************************************************"
#
#	sudo cp warframe.png /usr/local/share/pixmaps/
#
#	echo "[Desktop Entry]" > warframe.desktop
#	echo "Encoding=UTF-8" >> warframe.desktop
#	echo "Name=Warframe" >> warframe.desktop
#	echo "GenericName=Warframe" >> warframe.desktop
#	echo "Warframe" >> warframe.desktop
#	echo "Exec=/usr/local/bin/warframe \"\$@\"" >> warframe.desktop
#	echo "Icon=/usr/local/share/pixmaps/warframe.png" >> warframe.desktop
#	echo "StartupNotify=true" >> warframe.desktop
#	echo "Terminal=false" >> warframe.desktop
#	echo "Type=Application" >> warframe.desktop
#	echo "Categories=Application;Game" >> warframe.desktop
#
#	sudo cp warframe.desktop /usr/local/share/applications/
#fi
#
#read -p "Would you like a desktop shortcut? y/n" -n 1 -r
#echo    # (optional) move to a new line
#if [[ $REPLY =~ ^[Yy]$ ]]
#then
#	echo "*************************************************"
#	echo "Creating warframe desktop shortcut."
#	echo "*************************************************"
#	cp /usr/local/share/applications/warframe.desktop /Users/$USER/Desktop/
#fi


echo "*************************************************"
echo "Installation complete! It is safe to delete this folder."
echo "*************************************************"
