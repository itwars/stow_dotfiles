#!/usr/bin/env bash 

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/vrh/.lmstudio/bin"
# End of LM Studio CLI section

