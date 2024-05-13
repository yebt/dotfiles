if [ -d "$HOME/.bookmarks" ]; then
    # Function to navigate to bookmarks
    goto() {
        local bookmarks_dir="$HOME/.bookmarks"
        # get bookmark
        local selected_bookmark="$1"
        if [ "$#" -eq 0 ]; then
            if command -v fzf &>/dev/null; then
                selected_bookmark=$(find "$bookmarks_dir" -type l -exec basename {} \; | fzf --prompt="Select bookmark: ")
                if [ -z "$selected_bookmark" ]; then
                    echo "Aborted"
                    return 0
                fi
            else
                echo "No argument provided. Install 'fzf' to use bookmark selection."
            fi
        fi
        bookmark="$bookmarks_dir/$selected_bookmark"
        # check symbolic link status
        [ ! -e "$bookmark" ] && echo "Error: $bookmark not exist" && return 1
        [ ! -L "$bookmark" ] && echo "Error: $bookmark is not a symbolic link" && return 1
        cd -P $bookmark
    }
    # Bash completion for the goto function
    _goto_completion() {
        set completion-ignore-case on
        local bookmarks_dir="$HOME/.bookmarks"
        local bookmarks
        bookmarks=$(find "$bookmarks_dir" -type l -exec basename {} \; 2>/dev/null)
        COMPREPLY=($(compgen -W "$bookmarks" -- "${COMP_WORDS[COMP_CWORD]}"))
    }

    # _goto_completion() {
    #     local bookmarks_dir="$HOME/.bookmarks"
    #     local bookmarks
    #     bookmarks=$(find "$bookmarks_dir" -type l -exec basename {} \; 2>/dev/null | tr '[:upper:]' '[:lower:]')
    #     local lowercase_input
    #     lowercase_input=$(echo "${COMP_WORDS[COMP_CWORD]}" | tr '[:upper:]' '[:lower:]')
    #     COMPREPLY=($(compgen -W "$bookmarks" -- "$lowercase_input"))
    # }


    complete -F _goto_completion goto

    # Configurable prefix for bookmarks
    BOOKMARK_PREFIX="@"

    # Function to add a bookmark
    # add_bookmark() {
    #     local dir=$1
    #     # Use current directory if $1 is not defined or is empty
    #     if [ -z "$dir" ]; then
    #         dir=$(pwd)
    #     fi
    #     local dir_name=$(basename "$dir")
    #     local bookmark_name=${BOOKMARK_PREFIX}${dir_name}
    #     # Check if bookmark already exists
    #     if [ -e ~/.bookmarks/${bookmark_name} ]; then
    #         read -p "Bookmark already exists. Do you want to overwrite it? (y/n): " choice
    #         case "$choice" in
    #             y | Y)
    #                 # Overwrite existing bookmark
    #                 ln -sf "$(realpath $dir)" ~/.bookmarks/${bookmark_name}
    #                 echo "Bookmark overwritten for directory: ${dir}"
    #                 ;;
    #             *)
    #                 echo "Bookmark not added. Choose a different name or use the existing bookmark."
    #                 ;;
    #         esac
    #     else
    #         # Create a symbolic link to the directory
    #         ln -s "$(realpath $dir)" ~/.bookmarks/${bookmark_name}
    #         echo "Bookmark added for directory: ${dir}"
    #     fi
    # }

    # Function to add a bookmark
    add_bookmark() {
        # Function to display help information
        display_help() {
            echo "Usage: $0 [options] [directory]"
            echo "Options:"
            echo "  --alias ALIAS  Use ALIAS as the bookmark name"
            echo "  --help         Display this help message"
        }

        local dir
        local alias_flag=false

        # Parse options
        while [ "$#" -gt 0 ]; do
            case "$1" in
                --alias)
                    shift
                    alias_flag=true
                    alias_name="$1"
                    ;;
                --help)
                    display_help
                    return
                    ;;
                *)
                    dir="$1"
                    ;;
            esac
            shift
        done

        # Use current directory if not provided
        if [ -z "$dir" ]; then
            dir=$(pwd)
        fi

        local dir_name=$(basename "$dir")

        if [ "$alias_flag" = true ]; then
            # Use alias as the bookmark name
            local bookmark_name=${BOOKMARK_PREFIX}${alias_name}
        else
            # Use directory name as the bookmark name
            local bookmark_name=${BOOKMARK_PREFIX}${dir_name}
        fi

        # Check if bookmark already exists
        if [ -e ~/.bookmarks/${bookmark_name} ]; then
            read -p "Bookmark already exists. Do you want to overwrite it? (y/n): " choice
            case "$choice" in
                y | Y)
                    # Overwrite existing bookmark
                    ln -sf "$(realpath "$dir")" ~/.bookmarks/${bookmark_name}
                    echo "Bookmark overwritten for directory: ${dir}"
                    ;;
                *)
                    echo "Bookmark not added. Choose a different name or use the existing bookmark."
                    ;;
            esac
        else
            # Create a symbolic link to the directory
            ln -s "$(realpath "$dir")" ~/.bookmarks/${bookmark_name}
            echo "Bookmark added for directory: ${dir}"
        fi
    }

    # Function to remove a bookmark
    remove_bookmark() {
        local bookmarks_dir=~/.bookmarks
        local bookmark_name=$1

        if [ -z "$bookmark_name" ]; then
            echo "No bookmark to remove"
            return 1
        fi

        # Check if bookmark exists
        #if [ -e "${bookmarks_dir}/${bookmark_name}" ]; then
        # change conditional to bad symlinks
        if [ -L "${bookmarks_dir}/${bookmark_name}" ]; then
            rm "${bookmarks_dir}/${bookmark_name}"
            echo "Bookmark removed for directory: ${bookmark_name}"
        else
            echo "Bookmark does not exist: ${bookmark_name}"
        fi
    }

    # Function to list bookmarks
    list_bookmarks() {

        if [ ! -d ~/.bookmarks ]; then
            echo -e "\033[91mNo bookmarks found.\033[0m"
            return
        fi
        echo -e "\033[1mList of Bookmarks:\033[0m"
        for bookmark in ~/.bookmarks/*; do
            bookmark_name=$(basename "$bookmark")
            target=$(readlink "$bookmark")
            #echo -e "  \033[94m$bookmark_name\033[0m -> \033[92m$target\033[0m"
            # Check if the symbolic link is valid
            if [ -e "$target" ]; then
                echo -e "  \033[94m$bookmark_name\033[0m -> \033[92m$target\033[0m"
            else
                echo -e "  \033[91m$bookmark_name\033[0m -> \033[91mInvalid Target\033[0m"
            fi
        done
    }

    # Alias for adding a bookmark
    alias bmadd='add_bookmark'

    # Alias for removing a bookmark
    alias bmrem='remove_bookmark'
    complete -o nospace -W "$(ls ~/.bookmarks)" remove_bookmark

    # Alias for listing bookmarks
    alias bmlist='list_bookmarks'

fi
