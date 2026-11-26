export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH=/opt/homebrew/bin:$PATH
export EDITOR=vim

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
alias ea="vim ~/.config/alacritty/alacritty.toml"
alias eh="vim ~/.hammerspoon/init.lua"
alias ..="cd .."

alias cdo="cd /Users/nikolaypisanchev/.config/openshell"

alias ec="vim /Users/nikolaypisanchev/.nixpkgs/darwin-configuration.nix"
alias sc="sudo darwin-rebuild switch"

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
# export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

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

export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS='--bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all'

FZF_SOURCED="yes"

PS1="> "

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion




#=========================================

alias cdl="cdg; cd latticeflow-core"
alias cdll="cdg; cd secondary"
alias cde="cdl; cd e2e"

# export LF_URL="http://titan.latticeflow.cloud:8848"
# export LF_URL="http://titan.latticeflow.cloud:8834"
# export LF_URL="http://titan.latticeflow.cloud:8832"
# export LF_URL="http://localhost:8080"
# export LF_URL="http://titan.latticeflow.cloud:8833"
# export LF_URL="http://titan.latticeflow.cloud:8888"
# export LF_URL="http://titan.latticeflow.cloud:8894"
# export LF_URL="http://titan.latticeflow.cloud:8891"
# export LF_URL="http://titan.latticeflow.cloud:8843"
# export LF_URL="http://titan.latticeflow.cloud:8891"
# export LF_URL="http://titan.latticeflow.cloud:8889"
# export LF_URL="http://localhost:8889"
# export LF_URL="http://titan.latticeflow.cloud:8833"
# export LF_URL="http://titan.latticeflow.cloud:8837"

function buildfe() {
    #activate venv
    python tools/build_js.py
    python tools/build_js_dev.py

    #cp -r front-end/dist/* cloud/latticeflow/cloud/static/

}

function start_web() {
    POSTGRES_USER=latticeflow POSTGRES_PASSWORD=latticeflow LF_DATABASE_MODE=postgres LF_JOB_QUEUE_ENABLED=True lf_start_web --debug --broker "redis://127.0.0.1:6379/0" --disable_error_monitoring

}

function start_workers() {
    POSTGRES_USER=latticeflow POSTGRES_PASSWORD=latticeflow LF_DATABASE_MODE=postgres lf_start_workers --debug --broker "redis://127.0.0.1:6379/0" --disable_error_monitoring
}

function run_db() {
    docker run -d --name latticeflow-db -p 5432:5432/tcp -v /Users/nikolaypisanchev/lf_docker_data/postgres:/var/lib/postgresql/data -e POSTGRES_DB=latticeflow -e POSTGRES_USER=latticeflow -e POSTGRES_PASSWORD=latticeflow postgres:15.2
}

function run_redis() {
    docker run -d --name latticeflow-redis -p 6379:6379/tcp -v /Users/nikolaypisanchev/lf_docker_data/redis:/data redis:6.2.6
}

function orion() {
    # ssh nikolay@latticeflow.ddns.net -p 4802
    ssh nikolay@31.164.228.194
}

function new_release() {
    gh workflow run new-release --ref master
}

function deploy_previous() {
    cdl
    git fetch
    last_release=$(git describe --tags --match docker-* $(git rev-list --tags docker-* --max-count=1))
    gh workflow run e2e --ref $last_release

}

# create gif
# ffmpeg -i name.mov -pix_fmt rgb8 -r 10 output.gif


# uv load
. "$HOME/.local/bin/env"

export LF_PLAYWRIGHT_DEFAULT_TIMEOUT_MS=7000

export LF_PLAYWRIGHT_INITIAL_PAGE_LOAD_TIMEOUT_MS=30000

# EKS deployment
# export LF_AIGO_USER="nikolay@latticeflow.ai"
# export LF_AIGO_PASS=""
# export LF_AIGO_URL="https://app.latticeflow.cloud"
# export HOVERFLY_ADMIN_URL="http://titan.latticeflow.cloud:9908"
# export HOVERFLY_SIMULATION_URL="http://titan.latticeflow.cloud:9808"
# export HOVERFLY_USERNAME=""
# export HOVERFLY_PASSWORD=""

# qa1
# export LF_AIGO_USER="admin@latticeflow.ai"
# export LF_AIGO_PASS=""
# export LF_AIGO_URL="https://aigo.qa1.latticeflow.cloud"
# export HOVERFLY_ADMIN_URL="http://titan.latticeflow.cloud:9908"
# export HOVERFLY_SIMULATION_URL="http://titan.latticeflow.cloud:9808"
# export HOVERFLY_USERNAME=""
# export HOVERFLY_PASSWORD=""
# export HOVERFLY_IS_EXTERNAL=True

# qa2
# export LF_USER="e2e-tests-user@latticeflow.ai"
# export LF_PASS=""
# export LF_URL="https://aigo.qa2.latticeflow.cloud"
# export HOVERFLY_ADMIN_URL="http://titan.dub1.latticeflow.cloud:9908"
# export HOVERFLY_SIMULATION_URL="http://titan.dub1.latticeflow.cloud:9808"
# export HOVERFLY_USERNAME=""
# export HOVERFLY_PASSWORD=""
# export HOVERFLY_IS_EXTERNAL=True

# 9108
export LF_URL="https://titan.dub1.latticeflow.cloud:9108"
export LF_USER="admin@latticeflow.ai"
export LF_PASS=""
export HOVERFLY_ADMIN_URL="http://localhost:9208"
unset HOVERFLY_SIMULATION_URL
unset HOVERFLY_IS_EXTERNAL

export LF_MAILPIT_URL="https://mailpit.k8s.qa1.int.cloudsphere.com"

export LF_CONSOLE_URL="https://qa1.int.cloudsphere.com/logon"

export LF_CONSOLE_WEBSOCKET_URL="wss://api.qa1.int.cloudsphere.com/communication"

export LF_CONSOLE_USER="admin@tenant3.com"

export LF_CONSOLE_ORG="tenant3"


#
# console
# export LF_URL="https://titan.dub1.latticeflow.cloud:9512"
# export LF_USER="admin@latticeflow.ai"
# export LF_PASS=""
# export HOVERFLY_ADMIN_URL="http://localhost:9712"
# unset HOVERFLY_SIMULATION_URL
# unset HOVERFLY_IS_EXTERNAL

# 8848
# export LF_URL="https://titan.dub1.latticeflow.cloud:8848"
# export LF_USER="admin@latticeflow.ai"
# export LF_PASS=""
# export HOVERFLY_ADMIN_URL="http://titan.dub1.latticeflow.cloud:9908"
# export HOVERFLY_SIMULATION_URL="http://titan.dub1.latticeflow.cloud:9808"
# export HOVERFLY_USERNAME=""
# export HOVERFLY_PASSWORD=""
# export HOVERFLY_IS_EXTERNAL=True

# 9104
# export LF_URL="https://titan.dub1.latticeflow.cloud:9104"
# export LF_USER="admin@latticeflow.ai"
# export LF_PASS=""
# export HOVERFLY_ADMIN_URL="http://localhost:9304"
# unset HOVERFLY_SIMULATION_URL
# unset HOVERFLY_IS_EXTERNAL


# external env hoverfly config:
# export HOVERFLY_ADMIN_URL="http://titan.latticeflow.cloud:9908"
# export HOVERFLY_SIMULATION_URL="http://titan.latticeflow.cloud:9808"
# export HOVERFLY_IS_EXTERNAL=True
# export HOVERFLY_USERNAME=""
# export HOVERFLY_PASSWORD=""

export LF_HOST_SSH_USER="nikolay"
# export LF_AIGO_URL="http://localhost:8080"
#
# export HOVERFLY_ADMIN_URL="http://localhost:9208"
# export HOVERFLY_ADMIN_URL="http://localhost:9204"
# export HOVERFLY_ADMIN_URL="http://localhost:9333"
# export LF_AIGO_URL="http://titan.latticeflow.cloud:9104"
# export HOVERFLY_ADMIN_URL="http://localhost:9204"


export JIRA_EMAIL="nikolay@latticeflow.ai"
export JIRA_API_KEY="adsa"


# export LF_AIGO_URL="http://localhost:9999"
# export HOVERFLY_ADMIN_URL="http://localhost:9990"
# export LF_AIGO_URL="http://localhost:9108"
# export LF_AIGO_URL="http://localhost:9100"
function ci() {
    ssh -i ~/.ssh/titan -l cicd_runner titan.latticeflow.cloud
}

function dynamo() {
    ssh dynamo.dub1.latticeflow.cloud -l nikolay
}

function deploy() {
    gh workflow run aigo-deploy-from-branch \
        --ref "$(git branch --show-current)" \
        -f LF_AIGO_PORT=9108 \
        -f LF_AIGO_HTTP_PORT=9308 \
        -f HOVERFLY_ADMIN_PORT=9208 \
        -f CREATE_ADMIN_AND_TEST_APP=true \
        -f POPULATE_DEPLOYMENT=true
        # -f LIFETIME='1 minute'
}

function e2e() {
    gh workflow run aigo-e2e-test \
        --ref "$(git branch --show-current)"
}

# opencode
export PATH=/Users/nikolaypisanchev/.opencode/bin:$PATH

# source '/Users/nikolaypisanchev/.bash_completions/lf.sh'

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/nikolaypisanchev/.lmstudio/bin"
# End of LM Studio CLI section
export KUBECONFIG=~/.kube/qa2-vmware-dub1.yaml
