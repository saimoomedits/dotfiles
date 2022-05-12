#!/usr/bin/env bash

GDBUS_MONITOR_PID=/tmp/notify-action-dbus-monitor.$$.pid
GDBUS_MONITOR=(gdbus monitor --session --dest org.freedesktop.Notifications --object-path /org/freedesktop/Notifications)

NOTIFICATION_ID="$1"
if [[ -z "$NOTIFICATION_ID" ]]; then
    echo "no notification id passed: $@"
    exit 1;
fi
shift

ACTION_COMMANDS=("$@")
if [[ -z "$ACTION_COMMANDS" ]]; then
    echo "no action commands passed: $@"
    exit 1;
fi

cleanup() {
    rm -f "$GDBUS_MONITOR_PID"
}

create_pid_file(){
    rm -f "$GDBUS_MONITOR_PID"
    umask 077
    touch "$GDBUS_MONITOR_PID"
}

invoke_action() {
    invoked_action_id="$1"
    local action="" cmd=""
    for index in "${!ACTION_COMMANDS[@]}"; do
        if [[ $((index % 2)) == 0 ]]; then
            action="${ACTION_COMMANDS[$index]}"
        else
            cmd="${ACTION_COMMANDS[$index]}"
            if [[ "$action" == "$invoked_action_id" ]]; then
                bash -c "${cmd}" &
            fi
        fi
    done
}

monitor() {

    create_pid_file
    ( "${GDBUS_MONITOR[@]}" & echo $! >&3 ) 3>"$GDBUS_MONITOR_PID" | while read -r line
    do
        local closed_notification_id="$(sed '/^\/org\/freedesktop\/Notifications: org.freedesktop.Notifications.NotificationClosed (uint32 \([0-9]\+\), uint32 [0-9]\+)$/!d;s//\1/' <<< "$line")"
        if [[ -n "$closed_notification_id" ]]; then
           if [[ "$closed_notification_id" == "$NOTIFICATION_ID" ]]; then
               invoke_action close
               break
           fi
        else
            local action_invoked="$(sed '/\/org\/freedesktop\/Notifications: org.freedesktop.Notifications.ActionInvoked (uint32 \([0-9]\+\), '\''\(.*\)'\'')$/!d;s//\1:\2/' <<< "$line")"
            IFS=: read invoked_id action_id <<< "$action_invoked"
            if [[ "$invoked_id" == "$NOTIFICATION_ID" ]]; then
                invoke_action "$action_id"
                break
            fi
        fi
    done
    kill $(<"$GDBUS_MONITOR_PID")
    cleanup
}

monitor
