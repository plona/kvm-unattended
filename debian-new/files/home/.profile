# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

EDITOR=vim
export EDITOR

PATH=$PATH:$HOME/bin
export PATH

PAGER=less
LESS="-giJMS -x4 -FX"
export PAGER LESS
stty stop ''

mesg n

