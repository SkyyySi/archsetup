#!/usr/bin/env bash
# Error out if not root
[[ ${EUID} != 0 ]] || exit 1

# Install dependencies
pacman -S python3 python-pythondialog
