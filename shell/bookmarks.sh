if [ -d "$HOME/.bookmarks" ]; then
    export CDPATH=".:$HOME/.bookmarks:/"
    alias goto="cd -P"
    _goto() {
        local IFS=$'\n'
        COMPREPLY=($(compgen -W "$(/bin/ls ~/.bookmarks)" -- ${COMP_WORDS[COMP_CWORD]}))
    } && complete -F _goto goto

    # Configurable prefix for bookmarks
    BOOKMARK_PREFIX="@"

    # Function to add a bookmark
    add_bookmark() {
        local dir=$1
        # Use current directory if $1 is not defined or is empty
        if [ -z "$dir" ]; then
            dir=$(pwd)
        fi
        local dir_name=$(basename "$dir")
        local bookmark_name=${BOOKMARK_PREFIX}${dir_name}
        # Check if bookmark already exists
        if [ -e ~/.bookmarks/${bookmark_name} ]; then
            read -p "Bookmark already exists. Do you want to overwrite it? (y/n): " choice
            case "$choice" in
                y | Y)
                    # Overwrite existing bookmark
                    ln -sf "$(realpath $dir)" ~/.bookmarks/${bookmark_name}
                    echo "Bookmark overwritten for directory: ${dir}"
                    ;;
                *)
                    echo "Bookmark not added. Choose a different name or use the existing bookmark."
                    ;;
            esac
        else
            # Create a symbolic link to the directory
            ln -s "$(realpath $dir)" ~/.bookmarks/${bookmark_name}
            echo "Bookmark added for directory: ${dir}"
        fi
    }

    # Function to remove a bookmark
    remove_bookmark() {
        local bookmarks_dir=~/.bookmarks
        local bookmark_name=$1

        # Check if bookmark exists
        if [ -e "${bookmarks_dir}/${bookmark_name}" ]; then
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
            echo -e "  \033[94m$bookmark_name\033[0m -> \033[92m$target\033[0m"
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
