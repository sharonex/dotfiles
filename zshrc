# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#zmodload zsh/zprof

#GITSTATUS_LOG_LEVEL=DEBUG

# Environmet Variables
export PAGER=slit
export VISUAL=nvim
export EDITOR=nvim
export GOPATH="$HOME/go"

export DOTFILES_PATH="$HOME/utils"
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$GOROOT/bin:/Users/sharonavni/Library/Python/2.7/bin:$HOME/go/bin:$HOME/.cargo/bin"
export MAIN_WEKAPP_PATH="$HOME/projects/wekapp"
export WEKA_TEKA_COMMAND="$MAIN_WEKAPP_PATH/teka"
export WEKA_TEKA_COMMAND="./$MAIN_WEKAPP_PATH/teka"
export WEKA_SRC_VIEWER="~/projects/wekapp-viewer/emacs_viewer.sh"
export WEKA_COLLECT_WEKA_DIAGS=False

WEKA_USED_SYSTEM_PATH="$HOME/.weka_system"
export WEKA_USER="sharon.a"
export TEKA_PYENV_ON_REINSTALL=install

export bamboo_push_autosquash=yes
export bamboo_use_weld=yes

# Alias
alias l='ls -l'
alias ll='ls -la'
alias psg='ps -ef | grep'

alias q='cd ../'                           # Go back 1 directory level
alias qq='cd ../../'                       # Go back 2 directory levels
alias qqq='cd ../../../'                     # Go back 3 directory levels
alias qqqq='cd ../../../../'                  # Go back 4 directory levels
alias qqqqq='cd ../../../../../'               # Go back 5 directory levels

alias vim="nvim"
alias s="source ~/.zshrc"

alias h="cat $DOTFILES_PATH/helpers.txt| fzf | pbcopy"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='-m --height 50% --border'

export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt inc_append_history

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


# Enable owerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node
### End of Zinit's installer chunk

# https://github.com/zdharma/fast-syntax-highlighting#zinit
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

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
  local cmd="cat ~/utils/helpers.txt | grep -v -e ^\# -v -e ^$"
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
zi snippet ~/utils/pyenv.zsh

WEKA_BUILD_FORBIDDEN='t'
source ~/utils/emacs-vterm-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
