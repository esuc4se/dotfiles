########################################
# common
export LANG=ja_JP.UTF-8


########################################
# direnv
export EDITOR=vim
eval "$(direnv hook zsh)"


########################################
# node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


########################################
# shell

# zsh-completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
  fi

# zplug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-completions", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug mafredri/zsh-async, from:github
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme
zplug load

## peco
function peco-select-history() {
  local tac
    if which tac > /dev/null; then
      tac="tac"
    else
      tac="tail -r"
    fi
    BUFFER=$(history -n 1 | eval $tac | awk '!a[$0]++' | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history

bindkey '^R' peco-select-history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

## peco + ghq
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

## history settings
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

## ls color
export LSCOLORS=gxfxcxdxbxegedabagacag
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'

## ls color: completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# select-word-style
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified


########################################
# zsh completion option

# match lower & upper cases
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ dont completion
zstyle ':completion:*' ignore-parents parent pwd ..

# completion after sudo
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# completion ps command
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


########################################
# zsh option

setopt print_eight_bit
setopt no_beep
setopt no_flow_control
setopt ignore_eof
setopt interactive_comments
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_glob


########################################
# kubernetes

source <(kubectl completion zsh)

source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
# PROMPT='$(kube_ps1) '$PROMPT
PS1='$(kube_ps1)'$PS1

alias k='kubectl'
alias kauth='kubectl config set-credentials me --token="$(zms-cli -z https://zms-proxy.athenz.corp.yahoo.co.jp:4443/zms/v1 get-user-token | cut -d'\'' '\'' -f2)"'


########################################
# aliases

# global
alias -g L='| less'
alias -g G='| grep'
alias -g C='| pbcopy'

# ls
alias la='ls -al'
alias ll='ls -l'

# git
alias ga='git add .'
alias gcm='git commit -m'
alias gcom='git commit -m'
alias gca='git commit --amend'
alias gcab='git reset --soft HEAD@{1]'
alias gcar='git reset --soft HEAD@{1]'
alias grs='(){ git reset --soft }'
alias grh='(){ git reset --hard }'
alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gps='git push'
alias gph='git push'
alias gpl='git pull'
alias gs='git status'

# ghq
alias get='ghq get'
alias create='ghq create'
alias g='cd $(ghq root)/$(ghq list | peco)'
alias gh='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'

# npm & yarn
alias yu='yarn upgrade-interactive'
alias nu='npm-check -u'
alias nug='npm-check -u -g'
alias ng='npm list -g --depth=0'

# reboot shell
alias relogin='exec $SHELL -l'

# kill zcompdump
function zcompkill() {
  rm ~/.zcompdump;
  rm ~/.zcompdump.zwc;
  rm /usr/local/opt/zplug/zcompdump;
}
alias zcompkill=zcompkill

