# Setup Related

If you want to ssh into a machine and attach directly into a tmux session. The following should be added to the host in the .ssh/config file.
```bash
  RequestTTY yes
  RemoteCommand tmux new -A -s main_session
```

## Generating ssh keys
```bash
 ssh-keygen -t ed25519 -C "steini@mac.com"
```

## Font Install
In order to use things like Oh My ZSH you need to have a font package installed with support for things like the icons. One I like is Hack font. 
