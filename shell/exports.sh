# ------------------------------------------------------------------------------
# Codely theme config
# ------------------------------------------------------------------------------
export CODELY_THEME_MINIMAL=false
export CODELY_THEME_MODE="dark"
export CODELY_THEME_PROMPT_IN_NEW_LINE=true
export CODELY_THEME_PWD_MODE="home_relative" # full, short, home_relative
export CODELY_THEME_STATUS_ICON_OK=""
export CODELY_THEME_STATUS_ICON_KO=""

#export DOTLY_THEME="minimal"
export DOTLY_THEME="mod"
#export DOTLY_THEME="agnoster"

# ------------------------------------------------------------------------------
# Languages
# ------------------------------------------------------------------------------
export JAVA_HOME='/Library/Java/JavaVirtualMachines/amazon-corretto-15.jdk/Contents/Home'
export GEM_HOME="$HOME/.gem"
export GOPATH="$HOME/.go"
export COMPOSER_PATH="$HOME/.config/composer/vendor"

# ------------------------------------------------------------------------------
# Apps
# ------------------------------------------------------------------------------
if [ "$CODELY_THEME_MODE" = "dark" ]; then
	fzf_colors="pointer:#ebdbb2,bg+:#3c3836,fg:#ebdbb2,fg+:#fbf1c7,hl:#8ec07c,info:#928374,header:#fb4934"
else
	fzf_colors="pointer:#db0f35,bg+:#d6d6d6,fg:#808080,fg+:#363636,hl:#8ec07c,info:#928374,header:#fffee3"
fi

export FZF_DEFAULT_OPTS="--color=$fzf_colors --reverse"

export DOCKER_HOST=unix:///run/user/1000/podman/podman.sock

# ------------------------------------------------------------------------------
# Path - The higher it is, the more priority it has
# ------------------------------------------------------------------------------
path=(
	"$HOME/bin"
	"$HOME/.local/bin"
	"$DOTLY_PATH/bin"
	"$DOTFILES_PATH/bin"
	"$JAVA_HOME/bin"
	"$GEM_HOME/bin"
	"$GOPATH/bin"
	"$HOME/.cargo/bin"
	"$COMPOSER_PATH/bin",
	"/usr/local/opt/ruby/bin"
	"/usr/local/opt/python/libexec/bin"
	"/opt/homebrew/bin"
	"$HOME/.npm-global/bin"
	"/usr/local/bin"
	"/usr/local/sbin"
	"/bin"
	"/usr/bin"
	"/usr/sbin"
	"/sbin"
	"$path"
)

export path
