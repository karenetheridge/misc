# this file is install/generic/configs/.profile.d/ssh.sh

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
    {
        agent=$(readlink ~/.ssh/cached-ssh-agent)
        echo cached ssh agent: $agent
        export SSH_AUTH_SOCK="$agent"
    }

    # if cached agent socket is invalid, start a new one
    [ -S "$SSH_AUTH_SOCK" ] || {
        echo 'cached ssh agent is invalid; generating a new one'
        eval "$(ssh-agent)"
        ssh-add -t 25920000 -K ~/.ssh/id_rsa
        if [ -e ~/.ssh/id_ecdsa ]; then
            ssh-add -t 25920000 -K ~/.ssh/id_ecdsa;
        fi
        ln -sf $SSH_AUTH_SOCK ~/.ssh/cached-ssh-agent
    }

    echo agent in \$SSH_AUTH_SOCK is good: $SSH_AUTH_SOCK
}

# when starting, make sure we have an agent?
if [ -t 0 ]; then
    sagent
fi

# this will prompt for password, but allow us to use the
# keychain (e.g. to send mail) when logged in remotely.
unlock() {
    sagent
    security unlock-keychain ~/Library/Keychains/login.keychain
}
