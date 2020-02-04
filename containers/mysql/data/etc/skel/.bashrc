# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return;

############################################################### HELPER FUNCTIONS

function is_chroot() {
    if [[ ! -z ${chroot:+$chroot} ]]; then
        printf "${chroot:+:$chroot}";

        return 0;
    fi

    return 1;
}

function is_environment() {
    if [[ ! -z ${env:+$env} ]]; then
        printf "${env:+:$env}";

        return 0;
    fi

    return 1;
}

function is_screen() {
    [[ ! -x /usr/bin/screen ]] && return 127;

    if [[ ! -z "${STY}" ]]; then
        printf " %s" ${STY#*.};

        return 0;
    fi

    return 1;
}

function real_directory_path() {
    if [[ -d "${PWD}" ]]; then
        printf " %s" "$(realpath "${PWD}" | sed -e "s#^${HOME}#~#")";
    else
        printf " !MISSING!";
    fi
}

function current_git_branch() {
    [[ ! -x /usr/bin/git ]] && return 127;

    local branch=$(git branch 2> /dev/null);
    local branch_name;

    if [[ ! -z "${branch}" ]]; then
        branch_name="$(echo "${branch}" | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')";

        printf " %s%s" "${branch_name}"

        return 0;
    fi

    return 1;
}

######################################################################## HISTORY
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups;

# append to the history file, don't overwrite it
shopt -s histappend;

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1;
HISTFILESIZE=10000;

export HISTTIMEFORMAT="%Y-%m-%d %T → ";

############################################################################ SSH
# Start the SSH agent on every shell session
if [[ -x /usr/bin/ssh-agent ]]; then
    eval $(ssh-agent -s);
fi

############################################################################ GPG
export GPG_TTY=$(tty)

################################################################### PROMPT SETUP
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

# set a fancy prompt (non-color, unless we know we "want" color)
case "${TERM}" in
    xterm-color|*-256color)
        color_prompt=yes;
        ;;
esac

if [[ -n "${force_color_prompt}" ]]; then
    if [[ -x /usr/bin/tput ]] && tput setaf 1 >& /dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        color_prompt=yes;
    else
        color_prompt=;
    fi
fi

if [[ "${color_prompt}" == "yes" ]]; then
    euidps=();

    # PS1_COLOUR_RESET= \[\e[m\]

    # Foreground colours:
    # black        \[\e[0;30m\]
    # red          \[\e[0;31m\]
    # green        \[\e[0;32m\]
    # brown        \[\e[0;33m\]
    # blue         \[\e[0;34m\]
    # purple       \[\e[0;35m\]
    # cyan         \[\e[0;36m\]
    # light gray   \[\e[0;37m\]
    # gray         \[\e[1;30m\]
    # light red    \[\e[1;31m\]
    # light green  \[\e[1;32m\]
    # yellow       \[\e[1;33m\]
    # light blue   \[\e[1;34m\]
    # light purple \[\e[1;35m\]
    # light cyan   \[\e[1;36m\]
    # white        \[\e[1;37m\]

    # Background colours:
    # black  \[\e[40m\]
    # red    \[\e[41m\]
    # green  \[\e[42m\]
    # yellow \[\e[43m\]
    # blue   \[\e[44m\]
    # purple \[\e[45m\]
    # cyan   \[\e[46m\]
    # gray   \[\e[47m\]

    if [[ "${EUID}" -ne 0 ]]; then
        euidps+=("\[\e[1;30m\]");
        euidps+=("\[\e[1;36m\]");
        euidps+=("\u");
        euidps+=("\[\e[1;30m\]");
        euidps+=("@");
        euidps+=("\[\e[1;32m\]");
        euidps+=("\h");
        euidps+=("\[\e[1;31m\]");
        euidps+=("\$(is_chroot)");
        euidps+=("\[\e[1;35m\]");
        euidps+=("\$(is_environment)");
        euidps+=("\[\e[1;33m\]");
        euidps+=("\$(is_screen)");
        euidps+=("\[\e[m\]");
        euidps+=("\$(real_directory_path)");
        euidps+=("\[\e[1;30m\]");
        euidps+=("]");
        euidps+=("\[\e[m\]");
    else
        euidps+=("\[\e[1;33m\]");
        euidps+=("\[\e[41m\]");
        euidps+=("[");
        euidps+=("\u");
        euidps+=("@");
        euidps+=("\h");
        euidps+=("\$(is_chroot)");
        euidps+=("\$(is_environment)");
        euidps+=("\$(is_screen)");
        euidps+=("\$(real_directory_path)");
        euidps+=("]");
        euidps+=("\[\e[m\]");
    fi

    euidps=$(IFS=; echo "${euidps[*]}");

    PS1="${?} · ${euidps}\[\e[1;37m\]\$(current_git_branch)\[\e[m\] \\$ ";
    PS2=" · ";

    # enable color support of ls and also add handy aliases
    if [[ -x /usr/bin/dircolors ]]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)";

        alias ls='ls --color=auto';
        alias grep='grep --color=auto';
        alias fgrep='fgrep --color=auto';
        alias egrep='egrep --color=auto';
    fi

    # colored GCC warnings and errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01';

    unset -v euidps;
else
    PS1='$? · [\u@\h$(is_chroot)$(is_environment)$(is_screen)$(real_directory_path)]$(current_git_branch) \$ ';
    PS2=" · ";
fi

unset -v color_prompt;
unset -v force_color_prompt;

# If this is an xterm set the title to user@host:dir
case "${TERM}" in
    xterm*|rxvt*)
        PS1="\[\e]0;\u@\h:$(is_chroot)$(is_environment) \w\a\]${PS1}";
        ;;
    *)
        ;;
esac

########################################################################### MISC
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize;

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)";

# Add an "alert" alias for long running commands.
if [[ -x /usr/bin/notify-send ]]; then
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

############################################################## ALIAS DEFINITIONS
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
#
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [[ -f ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi

################################################################# BASH FUNCTIONS
# You may want to put all your additions into a separate file like
# ~/.bash_functions, instead of adding them here directly.
if [[ -f ~/.bash_functions ]]; then
    . ~/.bash_functions
fi

################################################################ BASH COMPLETION
# enable programmable completion features.
if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi
fi
