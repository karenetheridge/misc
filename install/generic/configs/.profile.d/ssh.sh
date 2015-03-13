
fix_ssh_agent()
{
    eval $(ssh-agent)
    ssh-add -t 25920000 -K ~/.ssh/id_rsa
}

# having troubles getting the passphrase remembered on a headless OSX session?
# try this:  ssh-add -K ~/.ssh/id_rsa



# adapted from
# https://superuser.com/questions/141044/sharing-the-same-ssh-agent-among-multiple-login-sessions

# attempt to connect to a running agent - cache SSH_AUTH_SOCK in ~/.ssh/
sagent()
{
    [ -S "$SSH_AUTH_SOCK" ] || {
        agent=$(readlink ~/.ssh/cached-ssh-agent)
        echo cached ssh agent: $agent
        export SSH_AUTH_SOCK="$agent"
    }

    # if cached agent socket is invalid, start a new one
    [ -S "$SSH_AUTH_SOCK" ] || {
        echo 'cached ssh agent is invalid; generating a new one'
        eval "$(ssh-agent)"
        ssh-add -t 25920000 -K ~/.ssh/id_rsa
        ln -sf $SSH_AUTH_SOCK ~/.ssh/cached-ssh-agent
    }

    echo agent is good? $SSH_AUTH_SOCK
}

