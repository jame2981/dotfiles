# gvm (Go Version Manager) initialization
export GVM_ROOT="$HOME/.gvm"

# Load Go environment (GOROOT, GOPATH, PATH, etc.)
[[ -f "$GVM_ROOT/environments/default" ]] && source "$GVM_ROOT/environments/default"

# Load gvm command for interactive use (gvm use, gvm install, etc.)
# Skip the cd hook (scripts/env/cd) that causes 'command not found' errors
# in non-interactive shells. The cd hook provides auto Go version switching
# via .go-version files; re-enable with: source "$GVM_ROOT/scripts/gvm"
if [[ -o interactive && -s "$GVM_ROOT/scripts/env/gvm" ]]; then
    source "$GVM_ROOT/scripts/functions" 2>/dev/null
    source "$GVM_ROOT/scripts/env/gvm"
fi
