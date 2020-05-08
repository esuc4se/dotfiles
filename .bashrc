########################################
# prompt
function __ps1_newline_login {
     if [[ -z "${PS1_NEWLINE_LOGIN}" ]]; then
       PS1_NEWLINE_LOGIN=true
     else
       printf '\n'
     fi
}

PROMPT_COMMAND='__ps1_newline_login'
export PS1="\[\e[1;95m\]\w\[\e[m\]\n\[\e[0;31m\]>\[\e[m\] "

########################################
# alias
alias la='ls -a'
alias ll='ls -l'
alias relogin='exec $SHELL -l'

# django
alias pyrn='python manage.py runserver 0.0.0.0:8080'
alias pymake='python manage.py makemigrations'
alias pymakeg='python manage.py makemigrations general'
alias pymig='python manage.py migrate'
alias pycsu='python manage.py createsuperuser'

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

# yarn
alias yu='yarn upgrade-interactive'
alias nu='npm-check -u'
alias nug='npm-check -u -g'
