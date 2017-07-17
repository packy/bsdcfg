#!/bin/bash

export GITDIR=$HOME/git
export BSDCFGBIN=$GITDIR/bsdcfg/bin

export LESS=FRX

function gg () { # go git
    cd $GITDIR/$1
}

function gg_autocomplete () {
    complete -W "$( ls -F $GITDIR | grep '\/$' | sed 's|/$||' )" gg
}
gg_autocomplete

alias gb='git branch'
alias gs='git status'
alias gd='git diff'

#
# git customizations
#

function git () {
    if [[ $EUID -eq 0 ]]; then
        echo "Don't run git as root!" 1>&2
        bash -c "exit 1"; # so the status is 1
    else
        /usr/local/bin/git "$@"
    fi
}

function is_git_dir () {
    [ -d .git ] || [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]
}

function parse_git_branch {
  WRAP=$1
  ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
  if [[ "$WRAP" = "wrap" ]] ; then
    echo "(${ref#refs/heads/})"
  else
    echo "${ref#refs/heads/}"
  fi
}

function make_git_titlebar {
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h: \w $(parse_git_branch wrap)\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac
}

newbranch () {
    if is_git_dir; then
        git branch "$@"
        echo Created git branch \"$1\"
        git checkout $1
    else
        echo Not a git dir: $(pwd)
    fi
}

_make_branch_name () {
    perl -e '$str = join "_", @ARGV; if ($ARGV[0] =~ /^\d+$/) { $str = "bug$str"; } print $str;' "$@"
}

last_sha () {
    git log -1 --pretty='%h'
}

squash_last () {
    git commit --fixup=$(last_sha) "$@"
}

local_commit_count () {
  echo $(git log --format=%H | \
            grep -v -f <(git log --format=%H "--grep=git-svn-id") | wc -l)
}

local_commits_only () {
  local N=$(local_commit_count)
  echo HEAD~$((N))..HEAD
}

gl () {
   git log $(local_commits_only)
   printf "\n"
}

gln () {
   git ln $(local_commits_only)
   printf "\n"
}

branch_has_no_tracking_information () {
  [[ $(git remote show | wc -l) -eq 0 ]]
}

commit_matching () {
    MATCHES=$(git status --porcelain | perl -e '
        $match = shift @ARGV;
        $match = qr/$match/;
        while (<STDIN>) {
            if ( m{$match} ) {
                chomp;
                substr($_, 0, 3, q{});
                s/.+\s+->//;
                print;
            }
        }' $1)
    git commit $MATCHES
}

git_commits_ahead () {
    DELTA=/tmp/git_upstream_status_delta.$$

    git for-each-ref --format="%(refname:short) %(upstream:short)" $(git-symbolic-ref HEAD) > $DELTA
    read local remote < $DELTA
    if [ ! -z "$remote" ]; then
        # this branch has an upstream remote
        git rev-list --left-right ${local}...${remote} -- 2>/dev/null >$DELTA || continue
        echo $(grep -c '^<' $DELTA)
    else
        git rev-list --left-right master..${local} -- 2>/dev/null >$DELTA || continue
        echo $(grep -c '^>' $DELTA)
    fi
    rm -f $DELTA
}
