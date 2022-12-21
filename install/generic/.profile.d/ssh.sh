# this file is install/generic/.profile.d/ssh.sh

fix_ssh_agent()
{
    eval $(ssh-agent)
    ssh-add -t 25920000 --apple-use-keychain ~/.ssh/id_rsa
}

# having troubles getting the passphrase remembered on a headless OSX session?
# try this:  ssh-add --apple-use-keychain ~/.ssh/id_rsa

# looking for a way to print your public key in md5-hex form?
# https://superuser.com/questions/1088165/get-ssh-key-fingerprint-in-old-hex-format-on-new-version-of-openssh
# ssh-keygen -l -E md5 -f ~/.ssh/id_ecdsa.pub


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
        ssh-add -t 25920000 --apple-use-keychain ~/.ssh/id_rsa
        if [ -e ~/.ssh/id_ecdsa ]; then
            ssh-add -t 25920000 --apple-use-keychain ~/.ssh/id_ecdsa;
        fi
        if [ -e ~/.ssh/id_ed25519 ]; then
            ssh-add -t 25920000 --apple-use-keychain ~/.ssh/id_ed25519;
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
