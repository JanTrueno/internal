#!/bin/sh

. /opt/muos/script/var/func.sh

. /opt/muos/script/var/device/storage.sh
. /opt/muos/script/var/device/sdl.sh

. /opt/muos/script/var/global/setting_general.sh
. /opt/muos/script/var/global/storage.sh

NAME=$1
CORE=$2
ROM=$3

export HOME=/root

export SDL_HQ_SCALER="$DC_SDL_SCALER"
export SDL_ROTATION="$DC_SDL_ROTATION"
export SDL_BLITTER_DISABLED="$DC_SDL_BLITTER_DISABLED"

if echo "$CORE" | grep -qE "flycast|morpheuscast"; then
    export SDL_NO_SIGNAL_HANDLERS=1
fi

if echo "$CORE" | grep -q "j2me"; then
	export JAVA_HOME=/opt/java
	PATH=$PATH:$JAVA_HOME/bin
fi

echo "retroarch" >/tmp/fg_proc

RA_CONF="$DC_STO_ROM_MOUNT/MUOS/retroarch/retroarch.cfg"

sed -i -e '/^system_directory/d' \
	-e '/^input_remapping_directory/d' \
	-e '/^rgui_config_directory/d' \
	-e '/^savefile_directory/d' \
	-e '/^savestate_directory/d' \
	-e '/^screenshot_directory/d' "$RA_CONF"

{
	echo "system_directory = \"$GC_STO_BIOS/MUOS/bios\""
	echo "input_remapping_directory = \"$GC_STO_CONFIG/MUOS/info/config/remaps\""
	echo "rgui_config_directory = \"$GC_STO_CONFIG/MUOS/info/config\""
	echo "savefile_directory = \"$GC_STO_SAVE/MUOS/save/file\""
	echo "savestate_directory = \"$GC_STO_SAVE/MUOS/save/state\""
	echo "screenshot_directory = \"$GC_STO_SCREENSHOT/MUOS/screenshot\""
} >>"$RA_CONF"

retroarch -v -f -c "$RA_CONF" -L "$DC_STO_ROM_MOUNT/MUOS/core/$CORE" "$ROM" &
RA_PID=$!

wait $RA_PID
