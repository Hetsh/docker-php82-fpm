#!/usr/bin/env bash


# Abort on any error
set -e -u

# Simpler git usage, relative file paths
CWD=$(dirname "$0")
cd "$CWD"

# Load helpful functions
source libs/common.sh
source libs/docker.sh

# Check dependencies
assert_dependency "jq"
assert_dependency "curl"

# Alpine Linux
update_image "amd64/alpine" "Alpine Linux" "false" "\d{8}"

# Packages
PKG_URL="https://pkgs.alpinelinux.org/package/edge/community/x86_64"
update_pkg "php81" "PHP8.1" "false" "$PKG_URL" "(\d+\.)+\d+-r\d+"
update_pkg "php81-fpm" "PHP8.1 FPM" "true" "$PKG_URL" "(\d+\.)+\d+-r\d+"

if ! updates_available; then
	#echo "No updates available."
	exit 0
fi

# Perform modifications
if [ "${1-}" = "--noconfirm" ] || confirm_action "Save changes?"; then
	save_changes

	if [ "${1-}" = "--noconfirm" ] || confirm_action "Commit changes?"; then
		commit_changes
	fi
fi
