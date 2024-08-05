INTERFACE=$( ip route get 10.10.3.1 | grep -oP "(?<=dev )[^ ]+" )
LOG_FILE="backlog_log.txt"

# Ensure the log file is empty
> $LOG_FILE
> "Dropped.txt"
while true; do
    # Get the current date and time
    #echo -n "$(date +'%Y-%m-%d %H:%M:%S'): " >> $LOG_FILE
    Time="$(date +%s.%N)"
    # Fetch the current backlog and append to the log
    queueSize="$Time $(tc -s qdisc show dev $INTERFACE | grep "backlog" | tail -1 | awk '{print $2 " " $3}')"
   dropped="$Time $(tc -s qdisc show dev $INTERFACE | grep "dropped" | tail -1 | awk '{print $7}')"
    echo "$queueSize" >> $LOG_FILE
    echo "$dropped" >> "Dropped.txt"
    # Wait for one second
    sleep 0.00001
done
