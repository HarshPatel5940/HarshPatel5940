if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x GPG_TTY (tty)

# brew
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/ruby/bin
fish_add_path /opt/homebrew/sbin

# misc
fish_add_path $HOME/.gem/ruby/3.3.0/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.spicetify
fish_add_path $HOME/.detaspace/bin

# mysql
function mysql-start
  /opt/homebrew/opt/mysql/bin/mysqld_safe --datadir\=/opt/homebrew/var/mysql 
end

function psql-start
  /opt/homebrew/opt/postgresql@14/bin/postgres -D /opt/homebrew/var/postgresql@14 
end

# docker
set -x docker /usr/local/bin/docker 

# aws cli 
alias aws /usr/local/bin/aws 

# rust
fish_add_path $HOME/.cargo/bin

# flutter
set -x CHROME_EXECUTABLE "/Applications/Arc.app/Contents/MacOS/Arc"

fish_add_path $HOME/.flutter/bin
fish_add_path $HOME/.pub-cache/bin

# golang
set -x GOPATH $HOME/.go
fish_add_path $HOME/.go/bin

# bun
set -x BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin

# deno
fish_add_path $HOME/.deno/bin
set -x DENO_DEPLOY_TOKEN ddp_7y9yYtIHRI9jcQ9sjAHZT4rZdUCLhQ23S8OC

# android sdk
fish_add_path $HOME/Library/Android/sdk/cmdline-tools/latest/bin
fish_add_path $HOME/Library/Android/sdk/platform-tools

set -x ANDROID_SDK_ROOT $HOME/Library/Android/sdk
set -x ANDROID_HOME $HOME/Library/Android/sdk

set -x PYTHONDONTWRITEBYTECODE true

# pnpm
set -x PNPM_HOME /Users/harshnpatel/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    fish_add_path $PNPM_HOME
end

set -x config $__fish_config_dir/config.fish

alias cat bat
alias bx bunx
alias px "pnpm dlx"

function ll
    set loc (walk --icons $argv); and cd $loc
    clear
end


# Git commands
alias gl "git log --graph --format=format:'%C(bold blue)%h%C(reset) -%C(bold yellow)%d%C(reset) %C(white)%s%C(reset)' --all"
alias gs "git status --short"
alias gc "git commit -m"
alias gc-undo "git reset --soft HEAD~"
alias ga "git add"
alias gp "git push"
alias co "git checkout"
alias pull "git pull"

alias rmf trash

if not type code >/dev/null 2>&1
    set -x code /usr/local/bin/code-insiders
else
    set -x code /usr/local/bin/code
end

function code -d "open vscode"
    if test -z $argv[1]
        $code .
    else if test $argv[1] != "."
        $code . $argv
    else
        $code $argv
    end
end

alias coed code

function open -d "open current directory"
    if test -z $argv[1]
        command open .
    else
        command open $argv
    end
end

function pyenv -d "create python environment"
    python3 -m venv venv
end

function workon -d "activate python environment"
    source venv/bin/activate.fish
end

function bubc -d "brew update and upgrade"
    brew update
    brew upgrade
    brew autoremove
    brew cleanup
end

function emt -d "Empty trash"
    set files /Users/harshnpatel/.Trash/*
    rm -rf $files
    echo $(set_color --bold brwhite)"Cleaned: "$(set_color --bold brred)"trash!"$(set_color normal)
end

function free -d "free up a tcp port"
    kill $(lsof -i $argv[1] | awk 'NR==2 {print $2}')
end

function ltx -d "local tunnel exec"
    bunx localtunnel --port $argv[1] --subdomain $argv[2] &
    set localtunnel_pid $last_pid
    sleep 2  # Adjust the sleep duration as needed
    set tunnel_password (curl -s https://loca.lt/mytunnelpassword)
    echo (set_color --bold brwhite)"Started: "(set_color --bold brred)"Password is $tunnel_password"(set_color normal)
    echo "LocalTunnel process ID: $localtunnel_pid"
    # If you want to stop the process, uncomment the line below
    # kill $localtunnel_pid
end

function cleanbuild -d "clean build files"
    find . -type d -d 1 \( -name node_modules -o -name dist -o -name build -o -name out -o -name target -o -name bin -o -name ".next" -o -name ".nuxt" -o -name ".cache" \) -exec rm -rf {} +
end

# ~/.config/fish/functions/nvm.fish
function nvm
  bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

# ~/.config/fish/functions/nvm_find_nvmrc.fish
function nvm_find_nvmrc
  bass source ~/.nvm/nvm.sh --no-use ';' nvm_find_nvmrc
end

# ~/.config/fish/functions/load_nvm.fish
function load_nvm --on-variable="PWD"
  set -l default_node_version (nvm version default)
  set -l node_version (nvm version)
  set -l nvmrc_path (nvm_find_nvmrc)
end

# ~/.config/fish/config.fish
# You must call it on initialization or listening to directory switching won't work
load_nvm > /dev/stderr
