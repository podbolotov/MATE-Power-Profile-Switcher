#!/usr/bin/env bash

if ! command -v powerprofilesctl 2>&1 >/dev/null
then
  echo "powerprofilesctl is not found. You have to install power-profiles-daemon."
  exit 1
fi

if ! command -v zenity 2>&1 >/dev/null
then
  echo "zenity is not found. Installation is interrupted."
  exit 1
fi

echo  
echo "MATE Power Profiles Switcher installation is started."
echo  
echo "Script will create directory .mate-power-profile-switcher in your \$HOME ($HOME),"
echo "place mate-power-profile-switcher.sh script in created directory, execute command \"chmod +x\" for"
echo "placed script, and create mate-power-profile-switcher.desktop for script file in $HOME/.local/share/applications"
echo  

while true; do
    read -p "Continue installation? (yes/no) " yn
    case $yn in
    
        "yes" ) 
        mkdir -p ~/.mate-power-profile-switcher
        
        wget \
        "https://raw.githubusercontent.com/podbolotov/MATE-Power-Profile-Switcher/refs/heads/main/mate-power-profile-switcher.sh" \
        -O ~/.mate-power-profile-switcher/mate-power-profile-switcher.sh
        
        chmod +x ~/.mate-power-profile-switcher/mate-power-profile-switcher.sh
        
        DESKTOP_FILE=$HOME/.local/share/applications/mate-power-profile-switcher.desktop
        touch $DESKTOP_FILE
        
        echo "#!/usr/bin/env xdg-open" >> $DESKTOP_FILE
        echo "" >> $DESKTOP_FILE
        echo "[Desktop Entry]" >> $DESKTOP_FILE
        echo "Version=1.0" >> $DESKTOP_FILE
        echo "Type=Application" >> $DESKTOP_FILE
        echo "Terminal=false" >> $DESKTOP_FILE
        echo "Exec=bash $HOME/.mate-power-profile-switcher/mate-power-profile-switcher.sh" >> $DESKTOP_FILE
        echo "Icon=ac-adapter" >> $DESKTOP_FILE
        echo "Name=MATE Power Profile Switcher" >> $DESKTOP_FILE
        echo "Categories=Utility" >> $DESKTOP_FILE
        echo "Hidden=false" >> $DESKTOP_FILE
        
        chmod +x $DESKTOP_FILE
        
        echo  
        echo "Installation complete. You can find \"MATE Power Profile Switcher\" icon in Accessories category in Applications menu."
        echo  
        
        break
        ;;
        
        "no" ) 
        exit
        ;;
        
        * ) 
        echo "Please answer yes or no."
        echo  
        ;;
        
    esac
done

