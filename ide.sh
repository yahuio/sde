#!/bin/sh
tmux new-session -d -n "nvim" "nvim $WORKSPACE"
tmux split-window -h
tmux -2 attach-session -d
