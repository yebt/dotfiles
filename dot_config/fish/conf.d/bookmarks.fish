#!/usr/bin/env fish

# Put it in ~/.config/fish

# Bookmark manager for the fish shell
# Functions:
# - bmadd: Add a bookmark
# - bmrm: Remove bookmarks
# - bmls: List bookmarks
# - goto: Interactive navigation to bookmarks using fzf

# Configuration
set -q BOOKMARK_DIR; or set -U BOOKMARK_DIR "$HOME/.bookmarks"

# Create bookmark directory if it doesn't exist
if not test -d $BOOKMARK_DIR
    mkdir -p $BOOKMARK_DIR
end

function bmadd -d "Add a bookmark: bmadd [route] [alias]"
    set -l route $argv[1]
    set -l alias $argv[2]
    
    # If no route is provided, use current directory
    if test -z "$route"
        set route (pwd)
    end
    
    # Convert to absolute path
    set route (realpath $route)
    
    # If no alias is provided, use basename of the route
    if test -z "$alias"
        set alias (basename $route)
    end
    
    # Check if path exists
    if not test -e $route
        echo "Error: Path '$route' does not exist"
        return 1
    end
    
    # Create symbolic link
    ln -sf $route $BOOKMARK_DIR/$alias
    
    echo "Bookmark added: '$alias' -> '$route'"
end

function bmrm -d "Remove bookmarks: bmrm [bookmark names...]"
    # If no arguments are provided, use fzf to select bookmarks to remove
    if test (count $argv) -eq 0
        # Check if bookmarks exist
        if test (count (ls -A $BOOKMARK_DIR)) -eq 0
            echo "No bookmarks found"
            return 1
        end
        
        # Use fzf to select bookmarks to remove
        set -l selected_bookmarks (ls -A $BOOKMARK_DIR | fzf --reverse --height 40%  --multi --prompt="Select bookmarks to remove: ")
        
        if test -z "$selected_bookmarks"
            echo "No bookmarks selected"
            return 0
        end
        
        for bookmark in $selected_bookmarks
            rm -f "$BOOKMARK_DIR/$bookmark"
            echo "Removed bookmark: $bookmark"
        end
    else
        # Remove specific bookmarks provided as arguments
        for bookmark in $argv
            if test -L "$BOOKMARK_DIR/$bookmark"
                rm -f "$BOOKMARK_DIR/$bookmark"
                echo "Removed bookmark: $bookmark"
            else
                echo "Bookmark '$bookmark' not found"
            end
        end
    end
end

function bmls -d "List all bookmarks"
    echo "Bookmarks in $BOOKMARK_DIR:"
    echo ""
    
    # Check if bookmarks exist
    if test (count (ls -A $BOOKMARK_DIR)) -eq 0
        echo "No bookmarks found"
        return 0
    end
    
    # List all bookmarks with their targets
    for bookmark in (ls -A $BOOKMARK_DIR)
        set -l target (readlink "$BOOKMARK_DIR/$bookmark")
        echo "$bookmark -> $target"
    end
end

function goto -d "Navigate to a bookmark using fzf"
    # Check if bookmarks exist
    if test (count (ls -A $BOOKMARK_DIR)) -eq 0
        echo "No bookmarks found"
        return 1
    end
    
    # Use fzf to select a bookmark
    # set -l selected_bookmark (ls -A $BOOKMARK_DIR | fzf --height ~40% --layout reverse  --prompt="Go to bookmark: ")
    set -l selected_bookmark (ls -A $BOOKMARK_DIR | gum filter --header="Go to bookmark: "  --prompt="> "  --indicator="➜")
    
    if test -z "$selected_bookmark"
        echo "No bookmark selected"
        return 0
    end
    
    set -l target (readlink "$BOOKMARK_DIR/$selected_bookmark")
    
    # Check if target still exists
    if not test -e $target
        echo "Error: Bookmark target '$target' does not exist anymore"
        echo "Do you want to remove this bookmark? (y/n)"
        read -l response
        if test "$response" = "y"
            bmrm $selected_bookmark
        end
        return 1
    end
    
    # Navigate to target
    cd $target
    echo "Navigated to $target"
end

# Autocomplete for bmrm
complete -c bmrm -f -a "(ls -A $BOOKMARK_DIR)" -d "Bookmark"

