[ -d ~/.fzf ] && echo '~/.fzf/ already exists, skipping...' && return 0

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --bin
