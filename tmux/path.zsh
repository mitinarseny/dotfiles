alias t="tmux has-session 2> /dev/null && tmux attach-session\; display-message 'attached: #{session_name}' || tmux new-session\; display-message 'created: #{session_name}'"
