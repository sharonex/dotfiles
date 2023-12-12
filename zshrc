# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

bindkey -e

bindkey "^[[3~" delete-char

#zmodload zsh/zprof

#GITSTATUS_LOG_LEVEL=DEBUG

# Environmet Variables
export VISUAL=nvim
export EDITOR=nvim
export GOPATH="$HOME/go"
export WORDCHARS=$WORDCHARS-

export DOTFILES="$HOME/.dotfiles"
export TMUX_CONF_LOCAL="$DOTFILES/tmux.conf.local"
export PATH="$PATH:/opt/homebrew/bin:$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$GOROOT/bin:$HOME/go/bin:$HOME/.cargo/bin"

export RUST_BACKTRACE=1
export OPENAI_API_KEY="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"

# Alias
alias vim="nvim"
alias l="ls -l"
alias ll="ls -la"
alias psg="ps -ef | grep"

alias q="cd ../"                           # Go back 1 directory level
alias qq="cd ../../"                       # Go back 2 directory levels
alias qqq="cd ../../../"                     # Go back 3 directory levels
alias qqqq="cd ../../../../"                  # Go back 4 directory levels
alias qqqqq="cd ../../../../../"               # Go back 5 directory levels

alias p="cd ~/work/pelanor/"
alias p2="cd ~/work/pelanor2/"

alias s="source ~/.zshrc"

alias h="cat $DOTFILES/helpers.txt| fzf | pbcopy"

alias b="git branch --show-current"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_DEFAULT_OPTS="-m --height 50% --border"

export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt inc_append_history

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Enable owerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word
# https://github.com/zdharma/fast-syntax-highlighting#zinit
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zinit light zdharma-continuum/zinit-annex-patch-dl

# others
zinit wait lucid for \
 supercrabtree/k \
 agkozak/zsh-z

zinit pack="binary+keys" for fzf
alias dircolors=gdircolors
zinit pack for ls_colors

# prompt
zinit load romkatv/powerlevel10k
#zinit load danihodovic/steeef
#zinit load sindresorhus/pure

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

setopt no_auto_menu

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

PATH="/Users/sharonavni/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/sharonavni/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/sharonavni/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/sharonavni/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/sharonavni/perl5"; export PERL_MM_OPT;

# ZSH configurations
__fbranch() {
  local cmd="git recent | sed 's/*/ /g' | tac"
  setopt localoptions pipefail no_aliases 2> /dev/null
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

__fzfcmd() {
  [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

fzf-branch-widget() {
  LBUFFER="${LBUFFER}$(__fbranch)"
  local ret=$?
  zle reset-prompt
  return $ret
}


__fhelper() {
  local cmd="cat $DOTFILES/helpers.txt | grep -v -e ^\# -v -e ^$"
  setopt localoptions pipefail no_aliases 2> /dev/null
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | pbcopy
  local ret=$?
  echo
  return $ret
}

fzf-helpers-widget() {
  LBUFFER="${LBUFFER}$(__fhelper)"
  local ret=$?
  zle reset-prompt
  return $ret
}

autoload -U select-word-style
select-word-style bash

zle -N fzf-branch-widget
zle -N fzf-helpers-widget
bindkey '^o' fzf-branch-widget
bindkey "\e[1;3D" backward-word # ⌥←
bindkey "\e[1;3C" forward-word # ⌥→
bindkey \^U backward-kill-line 

zi ice wait'3' lucid
#zi snippet ~/utils/pyenv.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
function select-aws-profile() {
    if [[ -n "$1" ]]; then
        export AWS_PROFILE="$1"
        if ! aws sts get-caller-identity &>/dev/null; then
            aws sso login
        fi
        return
    fi

    profiles=($(grep '\[profile ' ~/.aws/config | sed -e 's/\[profile \(.*\)\]/\1/'))

    local current_profile="$AWS_PROFILE"

    for profile in $profiles; do
        if [[ "$profile" == "$current_profile" ]]; then
            echo "* $profile" >> /tmp/aws_highlighted_profiles.txt
        else
            echo "  $profile" >> /tmp/aws_highlighted_profiles.txt
        fi
    done

    selected_profile=$(cat /tmp/aws_highlighted_profiles.txt | fzf | xargs)
    rm /tmp/aws_highlighted_profiles.txt

    selected_profile=$(echo $selected_profile | sed 's/^\* //')

    if [[ -n "$selected_profile" ]]; then
        export AWS_PROFILE="$selected_profile"
    fi

    if ! aws sts get-caller-identity &>/dev/null; then
        aws sso login
    fi
}
