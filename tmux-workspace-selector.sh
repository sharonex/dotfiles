#!/usr/bin/env zsh

wb() {
    # Get all tmux sessions that match the pelanor pattern
    local sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | grep -E "^pelanor[0-9]+$")

    if [ -z "$sessions" ]; then
        echo "No pelanor sessions found"
        return 1
    fi

    # Build a list of "branch_name:session_name" for fzf
    local branches_and_sessions=""

    # Convert sessions string to array and iterate properly
    while IFS= read -r session; do
        [ -z "$session" ] && continue

        # Extract the number from session name (e.g., pelanor1 -> 1)
        local num=$(echo "$session" | sed 's/pelanor//')
        local worktree_path="$HOME/work/pelanor$num"

        # Check if directory exists (could be main repo or worktree)
        if [ -d "$worktree_path" ]; then
            # Get the current branch name for this directory
            local branch=$(git -C "$worktree_path" branch --show-current 2>/dev/null)
            if [ -n "$branch" ]; then
                branches_and_sessions="$branches_and_sessions$branch:$session\n"
            fi
        fi
    done <<< "$sessions"

    if [ -z "$branches_and_sessions" ]; then
        echo "No valid directories with branches found"
        return 1
    fi

    # Use fzf to select a branch
    local selected=$(echo -e "$branches_and_sessions" | fzf --prompt="Select branch: " --height=40% --layout=reverse --with-nth=1 --delimiter=':')

    if [ -n "$selected" ]; then
        # Extract the session name from the selection
        local target_session=$(echo "$selected" | cut -d':' -f2)

        if [ -n "$TMUX" ]; then
            # We're inside tmux, switch to the session
            tmux switch-client -t "$target_session"
        else
            # We're outside tmux, attach to the session
            tmux attach-session -t "$target_session"
        fi
    fi
}

wb "$@"
