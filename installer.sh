#!/bin/sh
set -eu

# Configuration
REPO_URL="https://github.com/JuniorBecari10/dotfiles"
TARGET_DIR="dotfiles"
INSTALLER="$TARGET_DIR/installer.sh"

# Helpers
die() {
    printf 'Error: %s\n' "$1" >&2
    exit 1
}

need_cmd() {
    command -v "$1" >/dev/null 2>&1
}

# Ensure xbps is usable
if ! need_cmd xbps-install; then
    die "'xbps-install' not found. Certify that you're running this inside a Void Linux live CD."
fi

# Update xbps itself first
printf 'Updating xbps...\n'
xbps-install -Syu xbps

# Install required tools
if ! need_cmd git; then
    printf 'Installing git...\n'
    sudo xbps-install -y git
fi

# Clone repo
if [ -d "$TARGET_DIR/.git" ]; then
    printf 'dotfiles already exist at %s\n' "$TARGET_DIR"
else
    printf 'Cloning dotfiles repo...\n'
    git clone "$REPO_URL" "$TARGET_DIR" || die "git clone failed"
fi

# Sanity checks
[ -f "$INSTALLER" ] || die "installer not found: $INSTALLER"
[ -x "$INSTALLER" ] || chmod +x "$INSTALLER"

# Run installer
printf 'Running dotfiles installer...\n'
cd "$TARGET_DIR"
exec sh "./installer.sh"
