#! /bin/sh

killall -q polybar
echo "---" | tee -a /tmp/mybar.log

for i in /sys/class/hwmon/hwmon*/temp*_input; do 
    if [ "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*}))" = "k10temp: Tctl" ]; then
        export HWMON_PATH="$i"
        echo ${HWMON_PATH} | tee -a /tmp/mybar.log
    fi
done

polybar primary >> /tmp/mybar.log &

connected=$(xrandr | grep 'DP-2 connected')
if [ "${connected}" ]; then
    polybar secondary >> /tmp/mybar.log &
    polybar third >> /tmp/mybar.log &
fi