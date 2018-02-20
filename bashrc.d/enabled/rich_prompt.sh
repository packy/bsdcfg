#!/usr/bin/env bash
# for syntax highlightling in emacs, mostly

if [[ ${#ColorNames[*]} = 0 || -z "$IntenseBlack" || -z "$ResetColor" ]]; then
  resource_file $BASHRC_D/enabled/prompt-colors.sh
fi

function is_production_server () {
  if [[ "$PRODUCTION_SERVERS" != "" ]]; then
    IFS=':' read -r -a array <<< "$PRODUCTION_SERVERS"
    for index in "${!array[@]}"; do
      if [[ "${array[index]}" == "$HOSTNAME" ]]; then
        true
        return
      fi
    done
  fi
  false
}

# gp_format_exit_status RETVAL
#
# echos the symbolic signal name represented by RETVAL if the process was
# signalled, otherwise echos the original value of RETVAL

prompt_format_exit_status() {
  local RETVAL="$1"
  local SIGNAL
  # Suppress STDERR in case RETVAL is not an integer (in such cases, RETVAL
  # is echoed verbatim)
  if [ "${RETVAL}" -gt 128 ] 2>/dev/null; then
    SIGNAL=$(( ${RETVAL} - 128 ))
    kill -l "${SIGNAL}" 2>/dev/null || echo "${RETVAL}"
  else
    echo "${RETVAL}"
  fi
}


setPrompt ()
{
    local _PROMPT
    local _TITLE
    local _PRODTITLE
    local _PRODPROMPT
    local Time12a="\$(date +%H:%M)"

    if is_production_server; then
        _PRODTITLE="[PRODUCTION] "
        _PRODPROMPT="$BrightRedBg$BrightWhiteFg[PRODUCTION]$ResetColor "
    fi

    if [ $PROMPT_LAST_COMMAND_STATE = 0 ]; then
        LAST_COMMAND_INDICATOR="$PROMPT_COMMAND_OK";
    else
        LAST_COMMAND_INDICATOR="$PROMPT_COMMAND_FAIL";
    fi

    # replace _LAST_COMMAND_STATE_ token with the actual state
    PROMPT_LAST_COMMAND_STATE=$(prompt_format_exit_status ${PROMPT_LAST_COMMAND_STATE})
    LAST_COMMAND_INDICATOR="${LAST_COMMAND_INDICATOR//_LAST_COMMAND_STATE_/${PROMPT_LAST_COMMAND_STATE}}"


    _TITLE="$_PRODTITLE\u@\h:\w"

    local ps="${_PRODPROMPT}_LAST_COMMAND_INDICATOR_ $BoldGreenFg\h $BrightBlueFg$Time12a$ResetColor \\$ "
    _PROMPT="${ps//_LAST_COMMAND_INDICATOR_/${LAST_COMMAND_INDICATOR}}"

    export PS1="\[\e]0;$_TITLE\007\]$_PROMPT"
}

setLastCommandState ()
{
    PROMPT_LAST_COMMAND_STATE=$?
}

export PROMPT_COMMAND="setLastCommandState;setPrompt";

# indicator if the last command returned with an exit code of 0
if [ -z ${PROMPT_COMMAND_OK+x} ]; then
    PROMPT_COMMAND_OK="${Green}✔"
fi

# indicator if the last command returned with an exit code of other than 0
if [ -z ${PROMPT_COMMAND_FAIL+x} ]; then
    PROMPT_COMMAND_FAIL="${Red}✘-_LAST_COMMAND_STATE_"
fi

if is_production_server; then
  iTerm2_bgcolor    880000
  iTerm2_titlecolor FF0000
  printf "\e]1337;SetBadgeFormat=%s\a" $(hostname | b64encode -r foo)
fi
