# my custom bash goodness

# anything local?
if [ -e $HOME/.bashrc ]; then
	source $HOME/.bashrc
fi

# get our personal helpers
export PATH=$PATH:$HOME/.bin

# get me some vim cmd line luvin
set -o vi

# api keys, etc
if [ -e ~/.secrets/secrets ]; then
	source ~/.secrets/secrets
fi

#export PYTHONSTARTUP=$HOME/.pythonrc.py

# git related shellery
#export GIT_PS1_SHOWDIRTYSTATE=1
#source ~/.scriptdir/git-completion.bash

# this shows a colorized git repo dirty state
#export PS1='\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[01;31m\]$(__git_ps1 "(%s)")\[\033[00m\]\$ '

export PS1="\[\e[0;32m\]\u\[\e[m\]: \[\e[0;33m\]\w\[\e[m\] \[\e[0;32m\]]$\[\e[m\] "

# Setup some colors to use later in interactive shell or scripts
export COLOR_NONE='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[1;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'
export CLICOLOR=1

alias colorslist="set | egrep 'COLOR_\w*'" # Lists all colors
alias l="ls -lrtF"
alias ll="ls -lF"

#alias wgetff='wget --random-wait --wait 2 --mirror --no-parent -U "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6"'
#alias wgetie='wget --random-wait --wait 2 --mirror --no-parent -U "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"'
#alias wgetmac='wget --random-wait --wait 2 --mirror --no-parent -U "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_5_2; en-gb)"'

# pip command line completion is nice too
#which pip >/dev/null 2>&1 && eval "`pip completion --bash`"

# set my timezone to central
export TZ=CST6CDT

# #######################################
# OSX related aliases
# #######################################

#export APPLESCRIPT_DIR=$HOME/.applescripts

alias mvim="open -a MacVim"

alias gitx="open -a GitX"

# give me a "show info" from teh cmd line
#alias i="osascript ${APPLESCRIPT_DIR}/info.osa > /dev/null 2>&1"

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end


# virtualenv

vw=`which virtualenvwrapper.sh 2>/dev/null`
if [[ -n "$vw" ]] ; then
	export PIP_RESPECT_VIRTUALENV=true
	export WORKON_HOME=$HOME/Work/virtualenv
	source "$vw"
	export PIP_VIRTUALENV_BASE=$WORKON_HOME
fi

alias mve="mkvirtualenv --no-site-packages"



# helpers from troy on working with github pull reqs

function delp {
    # delete git pull request branch
    br=$(git branch | awk '$1=="*" {print $2; exit}')
    if ! echo "$br" | egrep -q '^pull-[0-9]+$'; then
        echo "\"$br\" is not a pull request branch" >&2
        return 1
    fi
    git checkout master
    git branch -D "$br"
}

function gitdir_top {
    w=$(git rev-parse --git-dir)
    if [[ -n $w ]] ; then
        echo "$w/.."
    fi
}

function git_upstream {
    # which remote name represents the current repo's upstream
    # if there's one named "upstream" pick that one, otherwise, default
    # to "origin".
    git remote | fgrep upstream || echo origin
}

function pullr {
    # pullr : run tests against a pull request
    # given a pull request number, merge the pull request with master,
    # and run testcases.  when finished, if all tests pass, optionally
    # remove the pull request branch.
    pullreq=${1?}
    delpull=$2  # any value deletes pull request branch on passed tests
    (cd $(gitdir_top) &&  # git pulls has to be done at the top
        git co master &&  # make sure we're on master
        git pull $(git_upstream) master && # make sure we're up-to-date
        git pulls update &&
        gh fetch-pull $pullreq merge &&
        fab test)
    rc=$?
    if [[ $rc -eq 0 ]] && [[ -n "$delpull" ]] ; then
        delp
        rc=$?
    fi
    return $rc
}




##
# Your previous /Users/Todd/.bash_profile file was backed up as /Users/Todd/.bash_profile.macports-saved_2016-10-06_at_23:57:07
##

# MacPorts Installer addition on 2016-10-06_at_23:57:07: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# Setting PATH for Python 3.5
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
export PATH

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
#export PS1="\u \[\033[32m\]\w\[\033[00m\] $ "

_complete_ssh_hosts ()
{
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                        cut -f 1 -d ' ' | \
                        sed -e s/,.*//g | \
                        grep -v ^# | \
                        uniq | \
                        grep -v "\[" ;
                cat ~/.ssh/config | \
                        grep "^Host " | \
                        awk '{print $2}'
                `
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
}
complete -F _complete_ssh_hosts ssh

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH


# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

# Setting PATH for Python 3.8
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
export PATH
