#!/usr/bin/env bash
# Runs graphify's hook guard; silently does nothing if graphify isn't installed.
command -v graphify >/dev/null 2>&1 || exit 0
exec graphify hook-guard "$@"
