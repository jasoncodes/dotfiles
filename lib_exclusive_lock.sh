function trap_add() # FUNC SIGSPEC...
{

    local FUNC="$1"
    shift

    for SIGSPEC
    do
        if [ "`trap -p $SIGSPEC`" == "" ]
        then
            # no existing trap
            trap "$FUNC;" "$SIGSPEC"
        else
            if [[ "$(trap -p "$SIGSPEC")" =~ ^trap\ --\ \'([^\']+)\;\'\ $SIGSPEC$ ]]
            then
                # add to existing trap
                trap "${BASH_REMATCH[1]};$FUNC;" "$SIGSPEC"
            else
                echo "Failed to extract existing trap:" >&2
                trap -p "$SIGSPEC" >&2
                exit 1
            fi
        fi
    done

}

function exclusive_lock_try() # [lockname]
{

    local LOCK_NAME="${1:-`basename $0`}"

    LOCK_DIR="/tmp/.${LOCK_NAME}.lock"
    local LOCK_PID_FILE="${LOCK_DIR}/${LOCK_NAME}.pid"

    if [ -e "$LOCK_DIR" ]
    then
        local LOCK_PID="`cat "$LOCK_PID_FILE" 2> /dev/null`"
        if [ ! -z "$LOCK_PID" ] && kill -0 "$LOCK_PID" 2> /dev/null
        then
            # locked by non-dead process
            echo "\"$LOCK_NAME\" lock currently held by PID $LOCK_PID"
            return 1
        else
            # orphaned lock, take it over
            ( echo $$ > "$LOCK_PID_FILE" ) 2> /dev/null && local LOCK_PID="$$"
        fi
    fi
    if [ "$LOCK_PID" != "$$" ] &&
        ! ( umask 077 && mkdir "$LOCK_DIR" && umask 177 && echo $$ > "$LOCK_PID_FILE" ) 2> /dev/null
    then
        local LOCK_PID="`cat "$LOCK_PID_FILE" 2> /dev/null`"
        # unable to acquire lock, new process got in first
        echo "\"$LOCK_NAME\" lock currently held by PID $LOCK_PID"
        return 1
    fi
    trap_add "/bin/rm -rf \"$LOCK_DIR\"" EXIT

    return 0 # got lock

}

function exclusive_lock_retry() # [lockname] [retries] [delay]
{

    local LOCK_NAME="$1"
    local MAX_TRIES="${2:-5}"
    local DELAY="${3:-2}"

    local TRIES=0
    local LOCK_RETVAL

    while [ "$TRIES" -lt "$MAX_TRIES" ]
    do

        if [ "$TRIES" -gt 0 ]
        then
            sleep "$DELAY"
        fi
        local TRIES=$(( $TRIES + 1 ))

        if [ "$TRIES" -lt "$MAX_TRIES" ]
        then
            exclusive_lock_try "$LOCK_NAME" > /dev/null
        else
            exclusive_lock_try "$LOCK_NAME"
        fi
        LOCK_RETVAL="${PIPESTATUS[0]}"

        if [ "$LOCK_RETVAL" -eq 0 ]
        then
            return 0
        fi

    done

    return "$LOCK_RETVAL"

}

function exclusive_lock_require() # [lockname] [retries] [delay]
{
    if ! exclusive_lock_retry "$@"
    then
        exit 1
    fi
}
