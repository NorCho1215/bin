#tmux send-key -t dev.2 "TEsT" C-m
tmux kill-window -t CCC
tmux new-window -a -n CCC
tmux send-key -t CCC "tmux split-window -v" C-m
sleep 1
tmux send-key -t CCC.2 "tmux split-window -h" C-m
sleep 1
tmux select-pane -t 1
sleep 1
tmux send-key -t CCC.1 "tmux split-window -h" C-m
sleep 1
