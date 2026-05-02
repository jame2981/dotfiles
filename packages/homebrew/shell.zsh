# Homebrew shell integration (macOS)
# brew is keg-only on Apple Silicon (/opt/homebrew) and Intel (/usr/local)
if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
