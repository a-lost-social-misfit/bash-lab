#!/usr/bin/env bash
#
# ~/.bashrc
# Based on Dave Eddy's bashrc (dave@daveeddy.com)
# Customized for me

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ============================================================
# History
# ============================================================
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=5000

# ============================================================
# Shell Options
# ============================================================
shopt -s checkwinsize
shopt -s cdspell
shopt -s extglob
shopt -s autocd   2>/dev/null || true
shopt -s dirspell 2>/dev/null || true

# ============================================================
# lesspipe
# ============================================================
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ============================================================
# Colors (Dave Eddy style: tputベース256色キャッシュ)
# ============================================================
COLOR256=()
COLOR256[0]=$(tput setaf 1)   # red (エラー表示用)
COLOR256[256]=$(tput sgr0)    # reset
COLOR256[257]=$(tput bold)    # bold

PROMPT_COLORS=()
set_prompt_colors() {
    local h=${1:-24}
    local color=
    local i=0
    local j=0
    for i in {22..231}; do
        ((i % 30 == h)) || continue
        color=${COLOR256[$i]}
        if [[ -z $color ]]; then
            COLOR256[$i]=$(tput setaf "$i")
            color=${COLOR256[$i]}
        fi
        PROMPT_COLORS[$j]=$color
        ((j++))
    done
}

# デフォルトテーマ (24)
set_prompt_colors 24

# user・@・hostの個別色指定
PS1_USER_COLOR=$(tput setaf 14)   # 明るいシアン
PS1_AT_COLOR=$(tput setaf 13)     # 明るいマゼンタ
PS1_HOST_COLOR=$(tput setaf 10)   # 明るいグリーン

# ============================================================
# Prompt
# ============================================================

_git_branch_ps1() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local git_color
    git_color=$(tput setaf 11)
    [[ -n $branch ]] && printf '%s' "${git_color}(${branch}) ${COLOR256[256]}"
}

_prompt_command() {
    local user=$USER
    local host=${HOSTNAME%%.*}
    local pwd=${PWD/#$HOME/\~}
    local ssh=
    [[ -n $SSH_CLIENT ]] && ssh='[ssh] '
    printf "\033]0;%s%s@%s:%s\007" "$ssh" "$user" "$host" "$pwd"
}
PROMPT_COMMAND='_prompt_command'

PROMPT_DIRTRIM=3

PS1='$(ret=$?; (($ret!=0)) && echo "\[${COLOR256[0]}\]($ret) \[${COLOR256[256]}\]")'
PS1+='\[${PS1_USER_COLOR}\]\[${COLOR256[257]}\]\u\[${COLOR256[256]}\]'
PS1+='\[${PS1_AT_COLOR}\]@\[${COLOR256[256]}\]'
PS1+='\[${PS1_HOST_COLOR}\]\[${COLOR256[257]}\]\h\[${COLOR256[256]}\] '
PS1+='\[${PROMPT_COLORS[5]}\]\W\[${COLOR256[256]}\] '
PS1+='$(_git_branch_ps1)'
PS1+='\[${PROMPT_COLORS[0]}\]\$\[${COLOR256[256]}\] '

# ============================================================
# 環境変数
# ============================================================
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export MANPAGER="batcat --paging=always --language=man --style=plain"
export MANROFFOPT="-c"
export MANWIDTH=120
export GREP_COLORS='mt=1;36'

# Support colors in less (Dave Eddy方式)
export LESS_TERMCAP_mb=$(tput bold; tput setaf 1)
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_se=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_ue=$(tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 2)

# ============================================================
# ls・grep カラー設定
# ============================================================
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -p --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ============================================================
# Aliases
# ============================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -lha'
alias la='ls -A'
alias l='ls -CF'

# タイポ修正 (Dave Eddy方式)
alias suod='sudo'
alias gerp='grep'
alias chomd='chmod'

# ツール
alias externalip='curl -sS https://ipinfo.io/ip'

# ============================================================
# Git
# ============================================================
alias ga='git add . --all'
alias gb='git branch'
alias gc='git clone'
alias gci='git commit -a'
alias gco='git checkout'
alias gd="git diff ':!*lock'"
alias gdf='git diff'
alias gi='git init'
alias gl='git log --oneline --graph --decorate'
alias gp='git push origin HEAD'
alias gr='git rev-parse --show-toplevel'
alias gs='git status'
alias gt='git tag'
alias gu='git pull'

# mainブランチ名を自動判別 (Dave Eddy方式)
gmb() {
    local main
    main=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)
    main=${main#origin/}
    [[ -n $main ]] || return 1
    echo "$main"
}

# mainブランチとのdiff
gbd() {
    local mb=$(gmb) || return 1
    git diff "$mb..HEAD"
}

# mainブランチにcheckout & pull
gcm() {
    local mb=$(gmb) || return 1
    git checkout "$mb" && git pull
}

# mainブランチをmerge
gmm() {
    local mb=$(gmb) || return 1
    git merge "$mb"
}

# ============================================================
# Useful functions (Dave Eddy方式)
# ============================================================

# カラーdiff
colordiff() {
    local red=$(tput setaf 1 2>/dev/null)
    local green=$(tput setaf 2 2>/dev/null)
    local cyan=$(tput setaf 6 2>/dev/null)
    local reset=$(tput sgr0 2>/dev/null)

    diff -u "$@" | awk "
    /^\-/ { printf(\"%s\", \"$red\"); }
    /^\+/ { printf(\"%s\", \"$green\"); }
    /^@/  { printf(\"%s\", \"$cyan\"); }
    { print \$0 \"$reset\"; }"

    return "${PIPESTATUS[0]}"
}

# 256色を全部表示
colors() {
    local i
    for i in {0..255}; do
        printf "\x1b[38;5;${i}mcolor %d\n" "$i"
    done
    tput sgr0
}

# epoch変換
epoch() {
    local num=${1:--1}
    printf '%(%B %d, %Y %-I:%M:%S %p %Z)T\n' "$num"
}

# 80列超えの行を表示
over() {
    awk -v c="${1:-80}" 'length($0) > c {
        printf("%4d %s\n", NR, $0);
    }'
}

# ============================================================
# cargo
# ============================================================
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
export PATH="$HOME/.cargo/bin:$PATH"

# ============================================================
# Completion
# ============================================================
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

true

