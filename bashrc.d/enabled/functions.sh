#!/bin/bash

function clean () {
    rm -fv *~ .*~
}

function rclean () {
    find . -name '*~' -o -name '.*~' | xargs rm -fv
}

function ts () {
    export TS=$(date '+%Y-%m-%d %H:%M:%S')
}

function is_in_list () {
  if [[ "$#" -lt 2 ]] || [[ "$#" -gt 3 ]]; then
    >&2 echo "Usage: is_in_list \"\$LIST\" item [separator]"
    false
    return
  fi
  LIST="$1" ITEM="$2" SEP=${3:-':'}
  if [[ "$LIST" != "" ]]; then
    IFS="$SEP" read -r -a _list <<< "$LIST"
    for index in "${!_list[@]}"; do
      if [[ "${_list[index]}" == "$ITEM" ]]; then
        true
        return
      fi
    done
  fi
  false
}
