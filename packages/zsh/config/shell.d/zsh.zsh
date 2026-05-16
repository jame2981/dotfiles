# Terminal — only set TERM as fallback, don't override terminal emulators
if [[ "$TERM" == "dumb" || -z "$TERM" ]]; then
    export TERM=xterm-256color
fi

# Format claude --stream-json output as readable conversation
claude-view-stream() {
    jq --unbuffered -r '
    select(.type == "assistant" or .type == "user" or .type == "system") |
    if .type == "system" then
        "system: \(.subtype // "?") model=\(.model // "?") cwd=\(.cwd // "?")"
    elif .type == "assistant" or .type == "user" then
        . as $ev | (($ev.message // {}).content // [])[]? |
        select((.type? // "") == "text") | .text // empty |
        "\($ev.type): \(.)"
    else
        "\(.type): \(. | tostring)"
    end
    ' | sed -u '/^$/d'
}
