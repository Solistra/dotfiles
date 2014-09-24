#!/bin/sh

# =============================================================================
# Variables
# =============================================================================
version='0.7'
# =============================================================================
# Functions
# =============================================================================
# report_status()
# -----------------------------------------------------------------------------
#   Checks the exit status of the last run command, reports uninstallation
# status, and exits with either 0 for success or 1 for failure.
# 
# NOTE: This script may also exit with a status of 2 if `gitsh` is not
# installed.
report_status(){
	if [ $? -eq 0 ] ; then
		echo "gitsh-$version uninstalled."
		exit 0
	else
		echo "gitsh-$version could not be uninstalled!"
		echo "Check for remnants in $loc."
		exit 1
	fi
}
# scripted_uninstall
# -----------------------------------------------------------------------------
#   Automates removal of `gitsh` and its associated files.
# 
# NOTE: This function assumes that `gitsh` was installed via the `install.sh`
# script available from this repository.
scripted_uninstall(){
	echo "Removing $(which gitsh)..."
	sudo rm -f `which gitsh`
	if [ $? -ne 0 ] ; then
		echo "$(which gitsh) could not be removed, aborting."
		return 1	
	else
		echo 'Removing gitsh man page...'
		sudo rm -f "$loc/share/man/man1/gitsh.1"
		if [ $? -ne 0 ] ; then
			echo 'gitsh man page could not be removed, aborting.'
			return 1
		fi
		echo "Removing $loc/share/gitsh directory..."
		sudo rm -rf "$loc/share/gitsh"
		if [ $? -ne 0 ] ; then
			echo "$loc/share/gitsh could not be removed, aborting."
			return 1
		fi
		echo "Removing gitsh-$version source directory..."
		sudo rm -rf "$loc/src/gitsh-$version"
		if [ $? -ne 0 ] ; then
			echo "gitsh-$version source could not be removed, aborting."
			return 1
		fi
	fi
}
# =============================================================================
# Script Body
# =============================================================================
if [ -x  "$(which gitsh)" ] ; then
	echo 'Uninstalling gitsh...'
	loc='/usr/local'
	scripted_uninstall
	report_status
else
	echo 'gitsh is not installed!'
	exit 2
fi
