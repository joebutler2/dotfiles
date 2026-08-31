# Version-manager / SDK shell inits, migrated over from the pre-dotfiles
# ~/.zshrc. Not secrets, just tool bootstrapping - safe to commit.

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init -)"

export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# sdkman - optional and on its way out in favor of mise. Set
# DOTFILES_SKIP_SDKMAN=1 in ~/.zshrc.local to disable without editing this
# file; once the mise migration is done, delete this block outright.
#
# THIS BLOCK MUST STAY LAST IN THIS FILE FOR SDKMAN TO WORK!
if [ -z "${DOTFILES_SKIP_SDKMAN:-}" ]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi
