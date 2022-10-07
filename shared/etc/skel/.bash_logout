################################################################################
# ~/.bash_logout                                                               #
################################################################################

# Disconnect all open ssh-agents
if [[ -x /usr/bin/ssh-agent ]]; then
    ssh-add -D
fi

# When leaving the console clear the screen to increase privacy
if [[ "${SHLVL}" = 1 ]]; then
    [[ -x /usr/bin/clear_console ]] && /usr/bin/clear_console -q
fi
