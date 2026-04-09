# Fix the Java Problem
export _JAVA_AWT_WM_NONREPARENTING=1

# Enable Powerlevel10k instant prompt. Should stay at the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
# -1 es para que sea ilimitado
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# To customize prompt, run `p10k configure` or edit ~/.config/p10k.zsh.
[[ -f ~/.config/p10k.zsh ]] && source ~/.config/p10k.zsh

# Manual configuration

PATH=/root/.local/bin:/snap/bin:/usr/sandbox/:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/jnicolaschc/.cargo/bin

# Manual aliases
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias cat='bat'

alias nv="nvim"
alias gft="git fetch"
alias gs="git status"
alias gco="git checkout"
alias gp="git pull"
alias gps="git push"
alias gc="git commit"
alias gcz="git cz"
alias ga="git add"
alias gl="git log"
alias gb="git branch"
alias gst="git stash"
alias gstp="git stash pop"
alias gf="git flow"

alias spotify="flatpak run io.github.hrkfdn.ncspot"
alias ping8="ping 8.8.8.8"
alias get_idf='. $HOME/esp/esp-idf/export.sh'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Plugins
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-sudo/sudo.plugin.zsh

# Functions
function mkt(){
	mkdir {nmap,content,exploits,scripts}
}

# Extract nmap information
function extractPorts(){
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}

# Set 'man' colors
function man() {
    env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    man "$@"
}

# fzf improvement
function fzf-lovely(){

	if [ "$1" = "h" ]; then
		fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
 	                echo {} is a binary file ||
	                 (bat --style=numbers --color=always {} ||
	                  highlight -O ansi -l {} ||
	                  coderay {} ||
	                  rougify {} ||
	                  cat {}) 2> /dev/null | head -500'

	else
	        fzf -m --preview '[[ $(file --mime {}) =~ binary ]] &&
	                         echo {} is a binary file ||
	                         (bat --style=numbers --color=always {} ||
	                          highlight -O ansi -l {} ||
	                          coderay {} ||
	                          rougify {} ||
	                          cat {}) 2> /dev/null | head -500'
	fi
}

function rmk(){
	scrub -p dod $1
	shred -zun 10 -v $1
}

# Finalize Powerlevel10k instant prompt. Should stay at the bottom of ~/.zshrc.
(( ! ${+functions[p10k-instant-prompt-finalize]} )) || p10k-instant-prompt-finalize
source ~/.config/powerlevel10k/powerlevel10k.zsh-theme


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# bun completions
[ -s "/home/jnicolaschc/.bun/_bun" ] && source "/home/jnicolaschc/.bun/_bun"

# variables
export IDF_PATH="$HOME/esp/esp-idf"
export LATEX_ENV="/opt/latex_env"
export XPDFR_HOME="/opt/XpdfReader/XpdfReader-linux64-4.04"
export CHATGPT_HOME="/opt/chatgpt"
export MY_CUSTOM_BASH="/opt/my-custom-bash"
export MY_LOCAL_HOME="/home/jnicolaschc/.local"
export TERMPDF_HOME="/opt/termpdf.py"
export IDEA_HOME="/opt/idea-IU-232.9559.62"
export KITTY_HOME="$HOME/.local/kitty.app"
export BUN_INSTALL="$HOME/.bun"
export GO_HOME="/usr/local/go"
export PIO_HOME="$HOME/.platformio/penv"
# export PYENV_ROOT="$HOME/.pyenv"
export DETA_HOME="/home/jnicolaschc/.detaspace"
# command -v pyenv >/dev/null || export PATH="$PATH:$PYENV_ROOT/bin"
# eval "$(pyenv init -)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Cambiar automáticamente a la versión especificada en el archivo .sdk-version
cd() {
    builtin cd "$@"
    if [[ -f .sdk-version ]]; then
        sdk use java $(cat .sdk-version)
    fi
}

# OpenAI API key
# Set this in your environment or in a separate .env file
# export OPENAI_API_KEY="your-key-here"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export ARUINO_HOME="$HOME/Arduino"

fpath=($HOME/.completion_zsh $fpath)

export PATH="$PATH:$HOME/.phpenv/bin"
eval "$(pyenv init -)"

if [ -f "$HOME/.local/share/dnvm/env" ]; then
    . "$HOME/.local/share/dnvm/env"
fi
eval "$(phpenv init -)"

PATH="/home/jnicolaschc/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/jnicolaschc/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/jnicolaschc/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/jnicolaschc/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/jnicolaschc/perl5"; export PERL_MM_OPT;

export PATH="$PATH:$MY_LOCAL_HOME/bin:$IDF_PATH/tools/:$IDF_PATH:$IDF_TOOLS:$LATEX_ENV:$XPDFR_HOME:$CHATGPT_HOME:$MY_CUSTOM_BASH:$TERMPDF_HOME:$IDEA_HOME/bin:$KITTY_HOME/bin:$BUN_INSTALL/bin:$DETA_HOME/bin:$GO_HOME/bin:$(go env GOPATH)/bin:$HOME/.phpenv/bin:$ARUINO_HOME/bin:$PIO_HOME/bin"




# fnm
FNM_PATH="/home/jnicolaschc/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/jnicolaschc/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# Load Angular CLI autocompletion.
source <(ng completion script)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/google-cloud-cli/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/google-cloud-cli/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/google-cloud-cli/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/google-cloud-cli/google-cloud-sdk/completion.zsh.inc'; fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jnicolaschc/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jnicolaschc/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jnicolaschc/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jnicolaschc/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


alias claude="/home/jnicolaschc/.claude/local/claude"
