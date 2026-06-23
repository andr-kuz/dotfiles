# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

bindkey -e  # emacs-like controls
alias v="nvim"
alias vim="nvim --listen /tmp/nvim.pipe -c 'set paste' -c 'lua require('\\''cmp'\\'').setup({ completion = { autocomplete = false } })' -c 'lua vim.diagnostic.config({ virtual_text = false, float = false })' -c 'set signcolumn=no'"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

plugins=(git battery)
#
# setopt promptsubst
# RPROMPT='$(battery_pct_prompt)'
#
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY

autoload -U select-word-style
select-word-style bash

# By making it empty, all non-alphanumeric characters (including /) become delimiters.
WORDCHARS=""

source "$HOME/.bash_functions"
