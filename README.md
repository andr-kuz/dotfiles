assuming you've cloned in your user's home dir:
```
nix run home-manager/release-25.11 -- init --switch --impure $HOME/.dotfiles/
```

or just run
```
sudo ./run.sh
```
to update both system and user settings
