
fix_ssh_agent()
{
    eval $(ssh-agent)
}

# having troubles getting the passphrase remembered on a headless OSX session?
# try this:  ssh-add -K ~/.ssh/id_rsa
