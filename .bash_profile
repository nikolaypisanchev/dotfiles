#tkpath="automation/sdm/tests"
tkpath="automation/sdm/tests/workflows"

export BASH_SILENCE_DEPRECATION_WARNING=1

alias ssh="TERM=xterm-256color ssh"
alias a="/usr/local/bin/aws"
alias al="a sso login"

alias ekm="vim /Users/nikolaypisanchev/qmk_firmware/keyboards/minidox/keymaps/nikolaypisanchev/keymap.c"

TEST_RUNNER="testing-nikolay03"

export EDITOR="/usr/local/bin/vim"
GIT_FOLDER="~/git"
FORMS_PROJECT="$GIT_FOLDER/forms"
FORMS_FORMS="$FORMS_PROJECT/forms"
VIM_FOLDER="~/.vim"

HISTSIZE=20000
HISTFILESIZE=20000

alias dot='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'

alias v="vim"
alias eb="vim ~/.bash_profile"
alias sb="source ~/.bash_profile"
alias elc="vim $FORMS_PROJECT/forms/automation/settings/configs/local_config.json"
alias eas="vim $FORMS_PROJECT/forms/automation/settings/settings.py"

alias cdg="cd $GIT_FOLDER"
alias cdf="cd $FORMS_PROJECT"
alias cdff="cd $FORMS_FORMS"
alias cda="cd $FORMS_PROJECT/forms/automation"
alias cdh="cd ~/hs"
alias cdv="cd $VIM_FOLDER"
alias cdvs="cd $VIM_FOLDER/pack/koko/start"
alias ea="vim ~/.config/alacritty/alacritty.yml"
alias eh="vim ~/.hammerspoon/init.lua"
alias ..="cd .."

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


alias pipi="pushd . && \
            cd $FORMS_FORMS/forms/requirements && \
            pip install -r form_extraction_dev.txt && \
            popd"

alias ls="ls -alG"
alias l="tree -a -L 1 -C"

alias b="bat"
alias bd="bat --diff"

function t() {
    pushd .
    cdff
    pytest --confcutdir=automation/ -rA -v  --junitxml=report.xml --html=report.html --self-contained-html -s -m $1 --pdb -p no:django -p no:logging --show-capture=all --ignore automation/dedupe automation
    popd
}

function tk() {
    pushd .
    cdff
    pytest --confcutdir=automation/ -rA -v --html=report.html --self-contained-html -s -k $1 -p no:django -p no:logging --show-capture=all --ignore automation/dedupe automation
    popd
}   

function tkdb() {
    pushd .
    cdff
    pytest --confcutdir=automation/ -rA -v --html=report.html --self-contained-html -s -k $1 --pdb -p no:django -p no:logging --show-capture=all --ignore automation/dedupe --ignore automation/datagen $tkpath 
    popd
}

function tkp() {
    pushd .
    cdff
    pytest --confcutdir=automation/ -rA -v --html=report.html --self-contained-html -s -k $1 --pdb -p no:django -p no:logging --setup-plan --show-capture=all automation/hyper_extract/tests
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

function relpath() {
    python -c 'import os.path, sys;\
    print(os.path.relpath(sys.argv[1],os.path.expanduser(sys.argv[2])))' "$1" "${2-$PWD}"
}

function lc() {
    pushd .
    cdff
    for i in `gs -s | cut -c4-`; do lint $i; done;
    popd
}

function ldir() {
    pushd .
    RELPATH=$(relpath . "$FORMS_PROJECT/forms")
    cdff

    lint $RELPATH
    popd
}

function lsh() {
    pushd .
    cdf
    .circleci/helpers/lint-bash.sh
    popd
}

function egs() {
    vim $(sgs)
}

function sgs() {
    gs -s | cut -c4- | fzf
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

function tt() {
    ssh $TEST_RUNNER << 'EOF'
    tail -f /var/www/forms/forms/automation/tests.log -n 1000
EOF
}

function rmapp() {
    APP_HOST='testing6-master'
    if [ $1 -eq 0 ] || [ $1 -eq 1 ]
      then
        APP_HOST=${APP_HOST}01
    fi  

    if [ $1 -eq 2 ]
      then
        APP_HOST=${APP_HOST}02
    fi

    ssh $APP_HOST << 'EOF'
    docker rm -f $(docker ps -aqf "name=^hs_")
EOF
}
DB_HOST="testing-master-shared.cstfmv1i2ead.us-east-1.rds.amazonaws.com"
APP_HOST="testing6-master01"

function rmdb() {
    psql -h $DB_HOST -U forms DONOTUSE<<EOF
            drop database "FORMS_TESTING6";
            create database "FORMS_TESTING6" with owner "forms";
EOF
}

function dbcon() {
    psql -h $DB_HOST -U forms FORMS_TESTING_NIKOLAY
}

#PYENV
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

alias pya="pyenv activate forms"
alias pyb="pyenv activate b"

#FZF
[ "$FZF_SOURCED" != "yes" ] && [ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude **/site-packages'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude **/site-packages'

export FZF_SOURCED="yes"


#export NVM_DIR=~/.nvm
#source $(brew --prefix nvm)/nvm.sh

export PATH="$HOME/.cargo/bin:/Applications/Racket v7.9/bin:$PATH"
pya

PS1="> "
