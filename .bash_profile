export BASH_SILENCE_DEPRECATION_WARNING=1

alias docker="podman"
alias ssh="TERM=xterm-256color ssh"
alias a="/usr/local/bin/aws"
alias aws2="/usr/local/bin/aws"
alias al="a sso login"

alias ekm="vim /Users/nikolaypisanchev/qmk_firmware/keyboards/minidox/keymaps/nikolaypisanchev/keymap.c"

alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
config config status.showUntrackedFiles no

function latest_rc() {
    a ecr describe-images \
        --region us-east-1 \
        --registry-id 794612149504 \
        --repository-name forms \
        --query 'imageDetails[?imageTags[? starts_with(@, `rc-`)]] | sort_by(@, &imagePushedAt) | reverse(@)[].imageTags[?starts_with(@, `rc-`)] | [0][0]' | tr -d '"'
        # --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[*]' \
         # | grep -oE "rc-[0-9A-Za-z]+"
        # --image-ids imageTag='latest_master' \

}

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


export EDITOR="/usr/local/bin/vim"
GIT_FOLDER="/Users/nikolaypisanchev/git"
FORMS_PROJECT="$GIT_FOLDER/forms"
FORMS_FORMS="$FORMS_PROJECT/forms"
AUTOMATION_FOLDER="$FORMS_FORMS/automation"
VIM_FOLDER="~/.vim"

HISTSIZE=200000
HISTFILESIZE=200000

alias dot='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'

alias v="vim"
alias eb="vim ~/.bash_profile"
alias sb="source ~/.bash_profile"
alias elc="vim $FORMS_PROJECT/forms/automation/settings/configs/local_config.json"
alias eas="vim $FORMS_PROJECT/forms/automation/settings/settings.py"

alias cdg="cd $GIT_FOLDER"
alias cdf="cd $FORMS_PROJECT"
alias cdff="cd $FORMS_FORMS"
alias cda="cd $AUTOMATION_FOLDER"
# alias cdh="cd ~/hs"
alias cdh="cd $GIT_FOLDER/hs-test-execution"
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
    # pytest --alluredir=allure_report --confcutdir=automation/ -rA -v --html=report.html --self-contained-html -s --pdb -p no:django -p no:logging --show-capture=all $1
    pytest --alluredir=allure_report --confcutdir=automation/ -rA -v --html=report.html --self-contained-html -s --pdb -p no:django --show-capture=all $1
    popd
}

function tk() {
    pushd .
    cdff
    pytest --confcutdir=automation/ -rA -v --html=report.html --self-contained-html -s -k $1 -p no:django -p no:logging --show-capture=all --ignore automation/dedupe --ignore automation/datagen $tkpath 
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

function runp() {
    pushd .
    cdff
    export PYTHONPATH="${PYTHONPATH}:${AUTOMATION_FOLDER}" && python automation/$1
    popd
}

function runpc() {
    # run python commands under the automation project
    pushd .
    cdff
    export PYTHONPATH="${PYTHONPATH}:${AUTOMATION_FOLDER}" && python -c "$1"
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
    # RELPATH=$(relpath . "$FORMS_PROJECT")
    cdff
    # cdf

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

TEST_RUNNER="testing-nikolay03"

function tt() {
    env=${1:-"$TEST_RUNNER"}
    ssh "$env" << 'EOF'
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

DEFAULT_AWX_ENV="testing-nikolay"
DEFAULT_AWX_BRANCH="master"

function startenv() {
    env=${1:-"$DEFAULT_AWX_ENV"}
    runpc "from automation.logger import log_init; from automation.common.awx.api import AwxAPI; log_init(); a=AwxAPI(); a.run_job(a.extract_template_id('$env', 'start-env'))"
}

function deploy() {
    branch=${1:-"$DEFAULT_AWX_BRANCH"}
    env=${2:-"$DEFAULT_AWX_ENV"}

    export AWX_EXECUTE_DEPLOY=true
    runpc "from automation.logger import log_init; from automation.common.awx.api import AwxAPI; log_init(); a=AwxAPI(); a.deploy_and_wait(a.extract_template_id('$env', 'build-and-deploy'), clear_db='yes', auth_type='local', BRANCH='$branch')"
}

function upgrade() {
    branch=${1:-"$DEFAULT_AWX_BRANCH"}
    env=${2:-"$DEFAULT_AWX_ENV"}

    export AWX_EXECUTE_DEPLOY=true
    runpc "from automation.logger import log_init; from automation.common.awx.api import AwxAPI; log_init(); a=AwxAPI(); a.deploy_and_wait(a.extract_template_id('$env', 'build-and-deploy'), clear_db='no', auth_type='local', BRANCH='$branch')"
}

function restore() {
    runpc "from automation.logger; from automation.common.awx.api import AwxAPI; from automation.conftest import restore_snapshot_by_name; a=AwxAPI(); restore_snapshot_by_name('28_2_4_connections_for_30', a)"
}

function build_image() {
    branch=$1
    runpc "from automation.logger import log_init; from automation.common.awx.api import AwxAPI; log_init(); a=AwxAPI(); a.run_job('458', BRANCH='$branch')"

}

function setup_flows_bb() {
    for i in $(seq 1 7); do 
        env_name="testing-flows$i"
        startenv "$env_name" && deploy "qa-r32.0.0" "$env_name" &
    done


}

#PYENV
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
fi
# eval "$(pyenv init --path)"

alias pya="pyenv activate forms"
alias pyb="pyenv activate b"

#FZF
[ "$FZF_SOURCED" != "yes" ] && [ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude **/site-packages'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude **/site-packages'

FZF_SOURCED="yes"


#export NVM_DIR=~/.nvm
#source $(brew --prefix nvm)/nvm.sh

export PATH="$HOME/.cargo/bin:/Applications/Racket v7.9/bin:$PATH"
pya

PS1="> "

export PATH="$HOME/.poetry/bin:$PATH"
