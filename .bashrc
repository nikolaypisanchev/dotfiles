export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH=/opt/homebrew/bin:$PATH

alias docker="docker"
alias ssh="TERM=xterm-256color ssh"

# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
#https://junegunn.kr/2016/07/fzf-git

is_in_git_repo() {
      git rev-parse HEAD > /dev/null 2>&1
  }

_gh() {
      is_in_git_repo || return
        git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
              fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
                  --header 'Press CTRL-S to toggle sort' \
                      --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
                        grep -o "[a-f0-9]\{7,\}"
                    }

fzf-down() {
  fzf --height 50% --min-height 20 --border --bind ctrl-/:toggle-preview "$@"
}


_gf() {
      is_in_git_repo || return
        git -c color.status=always status --short |
              fzf-down -m --ansi --nth 2..,.. \
                  --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
                    cut -c4- | sed 's/.* -> //'
                }


VIM_FOLDER="~/.vim"

HISTSIZE=200000
HISTFILESIZE=200000

alias v="vim"
alias eb="vim ~/.bashrc"
alias sb="source ~/.bashrc"

alias cdg="cd ~/git"
alias cdv="cd $VIM_FOLDER"
alias cdvs="cd $VIM_FOLDER/pack/koko/start"
alias ea="vim ~/.config/alacritty/alacritty.yml"
alias eh="vim ~/.hammerspoon/init.lua"
alias ..="cd .."

alias ec="vim /Users/nikolaypisanchev/.nixpkgs/darwin-configuration.nix"
alias sc="darwin-rebuild switch"

alias gs="git status"
alias gap="git add --patch"
alias gco="git checkout"
alias gcm='git commit -m "`git branch --show-current | cut -d - -f1,2` - " && git commit --amend'
alias ugcm="git reset --soft HEAD^"
alias gp="git push origin"
function gpf() {
    git push origin +`git branch --show-current`
} 

function gp1() {
    git push --set-upstream origin `git branch --show-current`
}

alias ls="ls -alG"
alias l="tree -a -L 1 -C"

alias b="bat"
alias bd="bat --diff"

function t() {
    pushd .
    cdff
    pytest --alluredir=allure_report --confcutdir=automation/ -rA -v --html=report.html --self-contained-html -s --pdb -p no:django --show-capture=all $1
    popd
}

function wdupdate() {
    TARGET_LOCATION="/usr/local/bin/"
    DRIVER_URL="https://chromedriver.storage.googleapis.com"
    DRIVER_ARCHIVE="chromedriver_mac64.zip"
    CHROME_VER=$(/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version | cut -d' ' -f3 | cut -d'.' -f1,2,3)
    WD_VER=`curl "$DRIVER_URL"/LATEST_RELEASE_"$CHROME_VER"`
    TMP_FILE=`mktemp`
    curl "$DRIVER_URL/$WD_VER/$DRIVER_ARCHIVE" -o $TMP_FILE
    unzip -o $TMP_FILE -d "$TARGET_LOCATION"
    rm $TMP_FILE
    echo "Updated to `$TARGET_LOCATION/chromedriver --version`"
}

function lint() {
    if [ $# -eq 0 ]
      then
        echo "No arguments supplied"
    fi
    p=${1:-"."}

    echo "linting $p"
    isort -rc $p
    black $p
    pycodestyle $p
    python run_pylint.py $p 
}

function egs() {
    vim $(sgs)
}

function sgs() {
    gs -s | cut -c4- | fzf -m
}

function ags() {
    gap $(sgs)
}

function dgs() {
    git diff $(sgs)
}

function cgs() {
    git checkout $(sgs)
}

#PYENV
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

#if command -v pyenv 1>/dev/null 2>&1; then
    #eval "$(pyenv init -)"
    #eval "$(pyenv init --path)"
    #eval "$(pyenv virtualenv-init -)"
#fi
# eval "$(pyenv init --path)"

#FZF
if command -v fzf-share >/dev/null; then
  source "$(fzf-share)/key-bindings.bash"
  source "$(fzf-share)/completion.bash"
fi

# [ "$FZF_SOURCED" != "yes" ] && [ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
#export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude **/site-packages'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude **/site-packages'

FZF_SOURCED="yes"

PS1="> "

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
