#!/bin/bash
# Strip out Meson's stubborn auto-injected Windows triple
ARGS=()
for arg in "$@"; do
    if [ "$arg" != "-mtriple=x86_64-windows" ]; then
        ARGS+=("$arg")
    fi
done
exec ldc2 "${ARGS[@]}"