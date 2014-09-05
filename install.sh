#!/bin/sh
#--
# Install Script
# =============================================================================
#   This script allows the user to safely and quickly install the desired
# configuration files from the "dotfiles" repository. It currently accepts two
# command line arguments: "--force" and "--help".
# 
# TODO: Make files able to determine where they should be placed.
# 
#++

# =============================================================================
# Functions
# =============================================================================
# print_usage()
# -----------------------------------------------------------------------------
#   Prints GNU-style usage information for this script.
print_usage() {
	echo "Usage: $(basename $0) [OPTION]"
	echo "Installs personal configuration files.\n"
	echo "     --force   overwrite existing files without confirmation"
	echo " -h, --help    display this help and exit\n"
}

# safe_install()
# -----------------------------------------------------------------------------
#   Installs the given filename from the repository if the appropriate hidden
# file does not already exist in the user's home directory -- otherwise,
# prompts the user to determine whether or not to install the file.
safe_install() {
	local file=$1
	local dotfile=$HOME/.$(basename $file)
	
	if [ -e $dotfile ] ; then
		read -p "$dotfile already exists. Overwrite? (y/n) " input
		if [ "$input" = "y" ] ; then force_install $file; fi
	else
		force_install $file
	fi
}

# force_install()
# -----------------------------------------------------------------------------
#   Installs the given filename from the repository as a hidden file in the
# user's home directory. This function is destructive!
force_install() {
	local dotfile=$HOME/.$(basename $1)
	
	echo "Installing $(basename $dotfile)..."
	if [ -e $dotfile ] || [ -h $dotfile ] ; then
		echo "  Removing original $(basename $dotfile)..."
		rm -f $dotfile
	fi
	ln -s $1 $dotfile && echo "  $dotfile installed:\n    -> $1"
}

# all_files()
# -----------------------------------------------------------------------------
#   Prints all valid configuration files in the repository in space-delimited
# alphabetical order.
all_files() {
	find `sh -c "cd $(dirname $0) ; pwd"`/files -type f | sort | xargs
}

# install_all()
# -----------------------------------------------------------------------------
#   Installs all of the configuration files available in the repository; files
# will be safely installed unless the `--force` option is passed to this
# script.
install_all() {
	for f in `all_files` ; do
		([ "$force" = 'on' ] && force_install $f) || safe_install $f
	done && echo 'Done.'
	exit 0
}

# =============================================================================
# Script Body
# =============================================================================
#   Process command line arguments and call `install_all()`.
while [ $# -gt 0 ] ; do
	case "$1" in
		--force)    force='on'            ;;
		-h|--help)  print_usage && exit 0 ;;
		*)          print_usage && exit 1 ;;
	esac
	shift
done && install_all
