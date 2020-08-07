########################################
# settings

# zplug
export ZPLUG_HOME=/usr/local/opt/zplug

# common
export LANG=ja_JP.UTF-8

# machine env
case ${OSTYPE} in
  darwin*)
    # pyenv:
    # !pb: homebrew + pyenv
    alias brew="env PATH=${PATH/\/Users\/${USER}\/\.pyenv\/shims:/} brew"

    # dev: nodebrew
    NODEBREW_HOME=/usr/local/var/nodebrew/current
    export NODEBREW_HOME
    export NODEBREW_ROOT=/usr/local/var/nodebrew
    export PATH=$PATH:$NODEBREW_HOME/bin
    ;;
  linux*)
    ;;
esac


########################################
# dev

# pyenv
if type pyenv >/dev/null 2>&1 ; then
  export PYENV_ROOT=$HOME/.pyenv
  export PATH=$PYENV_ROOT/bin:$PATH
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi


########################################
# zsh

# pure (propmt)
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit

if [ "`prompt -l | grep pure`" ] ; then
  prompt pure
fi

# zplug
source $ZPLUG_HOME/init.zsh
## zsh completion
zplug "zsh-users/zsh-completions", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:2
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
# aliases

# global aliases
alias -g L='| less'
alias -g G='| grep'

## 'C' clipboard copy
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi

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

