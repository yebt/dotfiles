#!/bin/bash

#######################################
### USER VARS

CAP_MAX=90
CAP_LOW=20
CAP_CRITICAL=9

NOTIFY_TIME=2000

TIME_CHECK_NORMAL=10
TIME_CHECK_LOW=5
TIME_CHECK_CRITICAL=3

#######################################
## WORK VARS

WORK_DIR_I3BAT=$(dirname $(realpath $0))

#######################################
## PID PROCCESS

PID_FILE="$WORK_DIR_I3BAT/.pidproc"

if [ -f "$PID_FILE" ]; then
   pid=$(cat $PID_FILE)
   if kill -0 $pid 2>/dev/null; then
      echo "Script is already running"
      exit 1
   else
      echo $$ > $PID_FILE
   fi
else
   echo $$ > $PID_FILE
fi

#######################################
notificate(){
	local message="$1"
	local important="${2:-normal}"
	notify-send -u $important \
		-t $NOTIFY_TIME \
		-a "i3 battery monitor" \
		-c "bat"  "i3 battery monitor" "$message"
}
#######################################
## CHECK LOOP

TIME_CHECK=0
while true; do
	TIME_CHECK=$TIME_CHECK_NORMAL
	actual_cap="$(cat /sys/class/power_supply/BAT0/capacity)"
	actual_status="$(cat /sys/class/power_supply/BAT0/status)"

	if [[ "$actual_status" == "Charging" ]]; then
		if [[ $actual_cap -ge $CAP_MAX ]]; then
			notificate "Baterry Full: $actual_cap" "low"
		fi
	elif [[ "$actual_status" == "Discharging" ]]; then
		if [[ $actual_cap -le $CAP_CRITICAL ]]; then
			notificate "CRITICAL LOW BATTERY: $actual_cap" "critical"
			TIME_CHECK=$TIME_CHECK_CRITICAL
		elif [[ $actual_cap -le $CAP_LOW ]]; then
			notificate "Low batery: $actual_cap"
			TIME_CHECK=$TIME_CHECK_LOW
		fi
	fi
####
	sleep $TIME_CHECK
done

