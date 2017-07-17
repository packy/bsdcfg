#!/usr/bin/env bash

if type function_exists 2>/dev/null | grep -q 'is a function'; then
    # this file has already been sourced
    return
fi

function is_local() {
    if [[ "$LOGIN_FROM" == "" ]]; then
        TTY=$(tty | sed -e "s/.*dev\/\(.*\)/\1/")
        if [[ "$TTY" != "" ]]; then
            LOGIN_FROM=$(w | grep $TTY | awk '{ print $3 }')
        fi
    fi
    [[ "$LOGIN_FROM" == "-" ]]
}

function is_interactive() {
    [[ $- == *i* ]]
}

function ts () {
    export TS=$(date '+%Y-%m-%d %H:%M:%S')
}

source $HOME/.bashrc.d/xterm.sh
save_cursor

function source_file () {
    FILE=$1
    PRINTERR=$2
    if [[ -f $FILE ]]; then
        save_cursor
        is_interactive && printf "Sourcing %s ...\n" $FILE
        source $FILE
        restore_cursor_clear_down
    elif [[ "$PRINTERR" != "" ]]; then
        is_interactive && echo ERROR: Unable to find $FILE >> /dev/stderr
    fi
}

function re_source_file () {
    FILE=$1
    PRINTERR=$2
    if [[ -f $FILE ]]; then
        is_interactive && restore_cursor
        is_interactive && printf "Sourcing %s ..." $(basename $FILE)
        is_interactive && clear_line_cursor_right
        source $FILE
    elif [[ "$PRINTERR" != "" ]]; then
        is_interactive && echoerr ERROR: Unable to find $FILE
    fi
}

# preferred minimal prompt: "user@host: path" in title, $ or # on command line
export PS1="\[\e]0;\u@\h: \w\007\]\\$ "

if [[ -e /usr/share/zoneinfo/America/New_York ]]; then
    export TZ=/usr/share/zoneinfo/America/New_York
fi

# leave this function as the last function in the file so we can test
# for its existence as a test of whether this file has been loaded
function function_exists () {
    type $1 | grep -q 'is a function'
}
