#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar 1>/dev/null ; do sleep 1; done

# Launch polybar
polybar top &
polybar bottom &

echo "Bar launched..."
