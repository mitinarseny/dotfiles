#!/bin/sh
case "$1" in
    .bashrc|.bash_aliases|.bash_environment|.zshrc)
        pygmentize -f 256 -l sh -O style=monokai "$1";;
	.py)
		pygmentize -f 256 -l py3 "$1";;

    *)
        if grep -q "#\!/bin/bash" "$1" 2> /dev/null; then
            pygmentize -f 256 -l sh "$1"
        else
			pygmentize -f 256 -O style=monokai "$1"
        fi
esac

exit 0