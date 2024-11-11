#!/usr/bin/env bash

#Set default english languages
export LC_ALL=en_US.UTF-8

# position values:
# 1 2 3
# 8 0 4
# 7 6 5
POSITION=0
YOFF=60
XOFF=0
FIELDS=SSID,SECURITY,BARS
FONT="DejaVu Sans Mono 12"

LIST=$(nmcli --fields "$FIELDS" device wifi list | sed '/^--/d')
# For some reason rofi always approximates character width 2 short... hmmm
RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }')+2))
# Dynamically change the height of the rofi menu
LINENUM=$(echo "$LIST" | wc -l)
# Gives a list of known connections so we can parse it later
KNOWNCON=$(nmcli connection show)
# Really janky way of telling if there is currently a connection
CONSTATE=$(nmcli -fields WIFI g)

CURRSSID=$(LANGUAGE=C nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes/ {print $2}')

if [[ ! -z $CURRSSID ]]; then
	HIGHLINE=$(echo  "$(echo "$LIST" | awk -F "[  ]{2,}" '{print $1}' | grep -Fxn -m 1 "$CURRSSID" | awk -F ":" '{print $1}') + 1")
fi

# HOPEFULLY you won't need this as often as I do
# If there are more than 8 SSIDs, the menu will still only have 8 lines
if [ "$LINENUM" -gt 8 ] && [[ "$CONSTATE" =~ "enabled" ]]; then
	LINENUM=8
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	LINENUM=1
fi


if [[ "$CONSTATE" =~ "enabled" ]]; then
	TOGGLE="󰖪  Disable Wi-Fi"
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	TOGGLE="󰖩  Enable Wi-Fi"
fi


CHENTRY=$(echo -e "Custom SSID\n$TOGGLE\n\n$LIST" | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " -lines "$LINENUM" -a "$HIGHLINE" -location "$POSITION" -yoffset "$YOFF" -xoffset "$XOFF" -font "$FONT" -width -"$RWIDTH" -theme windows/wifi.rasi )
CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')

# If the user inputs "manual" as their SSID in the start window, it will bring them to this screen
if [ "$CHENTRY" = "Custom SSID" ] ; then
	# Manual entry of the SSID and password (if appplicable)
	MSSID=$(echo "Enter the SSID of the network (SSID,password)" | rofi -dmenu -p "Manual Entry: " -font "$FONT" -lines 1 -theme windows/wifi.rasi)
	# Separating the password from the entered string
	MPASS=$(echo "$MSSID" | awk -F "," '{print $2}')

	# If the user entered a manual password, then use the password nmcli command
	if [ "$MPASS" = "" ]; then
		nmcli dev wifi con "$MSSID"
	else
		nmcli dev wifi con "$MSSID" password "$MPASS"
	fi

elif [ "$CHENTRY" = "󰖩  Enable Wi-Fi" ]; then
	nmcli radio wifi on

elif [ "$CHENTRY" = "󰖪  Disable Wi-Fi" ]; then
	nmcli radio wifi off

else

	# If the connection is already in use, then this will still be able to get the SSID
	if [ "$CHSSID" = "*" ]; then
		CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	fi

	# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
	if [[ $(echo "$KNOWNCON" | grep "$CHSSID") = "$CHSSID" ]]; then
		nmcli con up "$CHSSID"
	else
		if [[ "$CHENTRY" =~ "WPA2" ]] || [[ "$CHENTRY" =~ "WEP" ]]; then
			WIFIPASS=$(echo "If connection is stored, hit enter" | rofi -dmenu -p "WI-FI Password: " -lines 1 -font "$FONT" -theme windows/wifi.rasi )
		fi
		nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
	fi

fi