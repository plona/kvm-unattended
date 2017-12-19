# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -lh'
alias l='ls $LS_OPTIONS -1'
#
# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mysql='mysql --pager="less -giJMS -x4 -FX" --prompt="\u@\h [\d]> "'
alias mc='. /usr/lib/mc/mc-wrapper.sh -x'
alias ssh='ssh -e none -t'
alias apt-list-backports='aptitude search -t stretch-backports -F '\''%p %v -> %V'\'' '\''~U ~Abackports'\'''

# long history and other options

randstr() {
    cat /dev/urandom | tr -dc '[:alnum:]' | fold -w ${1:-16} | head -n ${2:-1}
}
hist() {
    history | awk '{$1=$2=$3=""; print $0}' | awk '{gsub(/^[[:cntrl:][:space:]]+|[[:cntrl:][:space:]]+$/,""); print;}'
}

HISTFILESIZE=1000000
HISTSIZE=1000000
HISTCONTROL=ignoreboth
HISTIGNORE='ls:bg:fg:history:vpn'
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND='history -a'

