#!/bin/sh
cd $WORKSPACE
tmux new-session -d -n "nvim" "nvim ." 
tmux split-window -h
tmux -2 attach-session -d
