################################################################################
# ~/.bashrc                                                                    #
################################################################################
# executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return;

########################################################################### MISC
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize;

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)";

############################################################### HELPER FUNCTIONS

function is_chroot() {
    if [[ -n ${chroot:+$chroot} ]]; then
        printf "${chroot:+:$chroot}";

        return 0;
    fi

    return 1;
}

function is_environment() {
    if [[ -n ${env:+$env} ]]; then
        printf "${env:+:$env}";

        return 0;
    fi

    return 1;
}

function is_screen() {
    [[ ! -x /usr/bin/screen ]] && return 127;

    if [[ -n "${STY}" ]]; then
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

    local branch;
    local branch_name;

    branch=$(git branch 2> /dev/null);

    if [[ -n "${branch}" ]]; then
        branch_name="$(echo "${branch}" | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')";

        printf " %s" "${branch_name}"

        return 0;
    fi

    return 1;
}

function current_git_status() {
    [[ ! -x /usr/bin/git ]] && return 127;

    local status;
    local status_text;

    status="$(git status 2>&1)";

    if grep -qi "your branch is up to date with" <<< "$status"; then
        status_text="";
    elif grep -qi "your branch is ahead of" <<< "$status"; then
        status_text="[AHEAD] ";
    elif grep -qi "your branch is behind" <<< "$status"; then
        if grep -qi "and can be fast-forwarded" <<< "$status"; then
            status_text="[BEHIND] ";
        else
            status_text="[BEHIND NOT FF-ABLE] ";
        fi
    elif grep -q "have diverged" <<< "$status"; then
        status_text="[DIVERGED] ";
    fi

    if grep -qi "nothing added to commit but untracked files present" <<< "$status"; then
        status_text+="new files found";
    elif grep -qi "untracked files" <<< "$status"; then
        status_text+="new files found";
    elif grep -qi "changes to be committed" <<< "$status"; then
        status_text+="ready to commit";
    elif grep -qi "changes not staged for commit" <<< "$status"; then
        status_text+="new changes found";
    fi

    printf " %s" "$status_text";

    return 0;
}

######################################################################## HISTORY
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups;

# append to the history file, don't overwrite it
shopt -s histappend;

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=;
HISTFILESIZE=;

export HISTTIMEFORMAT="%Y-%m-%d %T → ";

############################################################################ SSH
# Start the SSH agent on every shell session
[[ -x /usr/bin/ssh-agent ]] && eval "$(ssh-agent -s)";

############################################################################ GPG
export GPG_TTY=$(tty)

################################################################### PROMPT SETUP
# uncomment for a colored prompt, if the terminal has the capability; turned off
# by default to not distract the user: the focus in a terminal window should be
# on the output of commands, not on the prompt
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
    shell_array=();

    if [[ "${EUID}" -ne 0 ]]; then
        shell_array+=('\[\033[1;30m\]');
        shell_array+=('[');

        shell_array+=('\[\033[1;36m\]');
        shell_array+=('\u');

        shell_array+=('\[\033[1;30m\]');
        shell_array+=('@');

        shell_array+=('\[\033[1;32m\]');
        shell_array+=('\h');

        shell_array+=('\[\033[1;31m\]');
        shell_array+=('$(is_chroot)');

        shell_array+=('\[\033[1;35m\]');
        shell_array+=('$(is_environment)');

        shell_array+=('\[\033[1;33m\]');
        shell_array+=('$(is_screen)');

        shell_array+=('\[\033[m\]');
        shell_array+=('$(real_directory_path)');

        shell_array+=('\[\033[1;30m\]');
        shell_array+=(']');

        shell_string=$(IFS=; echo "${shell_array[*]}");
    else
        shell_string='\[\033[1;33;41m\][\u@\h$(is_chroot)$(is_environment)$(is_screen)$(real_directory_path)]';
    fi

    PS1="\${?} · ${shell_string}\[\033[m\]\[\033[1;37m\]\$(current_git_branch)\[\033[m\] \\$ ";
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

    unset -v shell_string;
else
    PS1='$? · [\u@\h$(is_chroot)$(is_environment)$(is_screen)$(real_directory_path)]$(current_git_branch)$(current_git_status) \$ ';
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

############################################################## ALIAS DEFINITIONS
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
#
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases;

################################################################# BASH FUNCTIONS
# You may want to put all your additions into a separate file like
# ~/.bash_functions, instead of adding them here directly.
[[ -f ~/.bash_functions ]] && source ~/.bash_functions;

################################################################ BASH COMPLETION
# enable programmable completion features.
if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi
fi
