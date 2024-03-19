# dotfiles

To init on a new system:

```
tmp=$HOME/dotenv-tmp; git clone --separate-git-dir=$HOME/.git --config status.showUntrackedFiles=no --config core.worktree=$HOME git@github.com:nikolaypisanchev/dotenv.git $tmp && rm -rf $tmp && git checkout && git checkout $HOME
```
