#
# ~/.bash_aliases
#

alias qq='exit';

alias ..='cd ../';
alias ll='ls -halF --group-directories-first';
alias la='ls -A';
alias l='ls -CF';

alias df='df -h';

alias psgrep='ps aux | grep -v grep | grep -i -e VSZ -e';
alias histgrep='history | grep';

############################################################ CONDITIONAL ALIASES

if [[ -x /usr/bin/find ]]; then
    alias findhere='find -O3 -L $PWD $@ 2>/dev/null';
fi

if [[ -x /usr/bin/peco ]]; then
    alias pspeak='ps aux | peco';
    alias histpeak='history | peco';

    if [[ -x /usr/bin/pkgman ]]; then
        alias pkgpeak='pkgman list installed | peco';
    fi
fi

if [[ -x /usr/bin/vim ]]; then
    alias difftool='vim -d';
fi

if [[ -x /usr/bin/xclip ]]; then
    alias clipboard='xclip -sel clip';
fi
