
fix_ssh_agent()
{
    eval $(ssh-agent)
    ssh-add -t 25920000 -K ~ether/.ssh/id_rsa
}

# having troubles getting the passphrase remembered on a headless OSX session?
# try this:  ssh-add -K ~/.ssh/id_rsa
