# libpq shell integration (macOS only)
# brew install libpq is keg-only — binaries, headers, and libs not in default paths
_libpq_prefix=""
if [ -d "/opt/homebrew/opt/libpq" ]; then
    _libpq_prefix="/opt/homebrew/opt/libpq"
elif [ -d "/usr/local/opt/libpq" ]; then
    _libpq_prefix="/usr/local/opt/libpq"
fi

if [ -n "$_libpq_prefix" ]; then
    path_prepend "$_libpq_prefix/bin"
    export LDFLAGS="${LDFLAGS:+$LDFLAGS }-L$_libpq_prefix/lib"
    export CPPFLAGS="${CPPFLAGS:+$CPPFLAGS }-I$_libpq_prefix/include"
    export PKG_CONFIG_PATH="${PKG_CONFIG_PATH:+$PKG_CONFIG_PATH:}$_libpq_prefix/lib/pkgconfig"
fi
unset _libpq_prefix
