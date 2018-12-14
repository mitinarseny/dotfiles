unsetopt MAIL_WARNING		# Don't print a warning message if a mail file has been accessed.
setopt NOTIFY				# Report status of background jobs immediately.

setopt HIST_BEEP			# Beep when accessing non-existent history.

setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD			# Push the old directory onto the stack on cd.

# Enable iTerm Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"