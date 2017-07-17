#!/usr/bin/env bash
# for syntax highlightling in emacs, mostly

export GREP_COLOR='30;43'
export GREP_OPTIONS='--color=auto'

export ACK_COLOR_FILENAME=red
export ACK_PAGER='less -FRX'
restore_cursor_clear_down
source_file $HOME/git/ack2/completion.bash
