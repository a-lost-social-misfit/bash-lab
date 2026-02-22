# ~/.profile
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

. "$HOME/.cargo/env"

PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\[\033[33m\]\$(git branch 2>/dev/null | grep ^\* | colrm 1 2 | sed s/^/\(/ | sed s/$/\)/)\[\033[00m\]# "

[ -f /etc/bash_completion ] && . /etc/bash_completion
