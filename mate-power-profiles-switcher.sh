#!/usr/bin/env bash

if ! command -v powerprofilesctl 2>&1 >/dev/null
then
  zenity --error \
  --title="powerprofilesctl is not found" \
  --text="You have to install power-profiles-daemon"
  exit 1
fi

CURRENT_PROFILE=$(powerprofilesctl get)

POWERSAVER_DEFAULT_STATE=FALSE
BALANCED_DEFAULT_STATE=FALSE
PERFORMANCE_DEFAULT_STATE=FALSE

case $CURRENT_PROFILE in

  power-saver)
    POWERSAVER_DEFAULT_STATE=TRUE
    ;;

  balanced)
    BALANCED_DEFAULT_STATE=TRUE
    ;;

  performance)
    PERFORMANCE_DEFAULT_STATE=TRUE
    ;;

  *)
    zenity --error \
    --title="Unable to get power profile" \
    --text="Unable to get current power profile.\n\
Script will be finished without profiles switching.\n\n\
Please, check that command \"powerprofilesctl get\" can be executed on your system without root permissions."
    exit 1
    ;;

esac


CHOSEN_PROFILE=$(zenity --list --radiolist \
  --title="MATE Power Profiles Switcher" \
  --width=350 --height=300 \
  --text="Choose power profile from the list bellow. \n\nYour current power profile: $CURRENT_PROFILE.\n" \
  --column="Select" --column="Profile" \
    $POWERSAVER_DEFAULT_STATE "power-saver" \
    $BALANCED_DEFAULT_STATE "balanced" \
    $PERFORMANCE_DEFAULT_STATE "performance")

if [[ "$CHOSEN_PROFILE" == "" ]]
then
  echo "Operation cancelled."
  exit 0
fi

if [[ "$CURRENT_PROFILE" != "$CHOSEN_PROFILE" ]]
then
  echo "Chosen profile is $CHOSEN_PROFILE."
  powerprofilesctl set $CHOSEN_PROFILE
  NEW_POWER_PROFILE=$(powerprofilesctl get)
  if [[ "$NEW_POWER_PROFILE" == "$CHOSEN_PROFILE" ]]
  then
    zenity --info \
    --width=300 \
    --title="Profile is successfully changed" \
    --text="Profile \"$CHOSEN_PROFILE\" is activated."
  else
    zenity --error \
  --title="Unable to set power profile" \
  --text="Unable to set chosen power profile.\n\
Script will be finished without profiles switching.\n\n\
Please, check that command \"powerprofilesctl set $CHOSEN_PROFILE\" can be executed on your system without root permissions.\n\n\
Current system profile: $NEW_POWER_PROFILE."
  fi
  exit 1
else
  echo "Profile $CHOSEN_PROFILE is already active."
  zenity --info \
  --width=300 \
  --title="Profile is not changed" \
  --text="Profile \"$CHOSEN_PROFILE\" is already active."
fi
