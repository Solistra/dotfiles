#!/bin/sh

# =============================================================================
# Functions
# =============================================================================
# report_status()
# -----------------------------------------------------------------------------
#   Checks the exit status of the last run command, reports uninstallation
# status, and exits with either 0 for success or 1 for failure.
# 
# NOTE: This script may also exit with a status of 2 if `hub` is not installed.
report_status(){
	if [ $? -eq 0 ] ; then
		echo 'hub uninstalled.'
		exit 0
	else
		echo 'hub could not be uninstalled!'
		echo 'Check for remnants in /usr/local.'
		exit 1
	fi
}
# scripted_uninstall()
# -----------------------------------------------------------------------------
#   Automates removal of `hub`, its associated `man` page, and source.
# 
# NOTE: This function assumes that `hub` was installed via the `install.sh`
# script available from this repository.
scripted_uninstall() {
	echo "Removing $(which hub)..."
	sudo rm -f `which hub`
	if [ $? -ne 0 ] ; then
		echo "$(which hub) could not be removed, aborting."
		return 1
	else
		echo 'Removing hub man page...'
		sudo rm -f /usr/local/share/man/man1/hub.1
		if [ $? -ne 0 ] ; then
			echo 'hub man page could not be removed, aborting.'
			return 1
		fi
		echo 'Removing hub source directory...'
		sudo rm -rf /usr/local/src/hub
		if [ $? -ne 0 ] ; then
			echo 'hub source could not be removed, aborting.'
			return 1
		fi
	fi
}
# =============================================================================
# Script Body
# =============================================================================
if [ -x  "$(which hub)" ] ; then
	echo 'Uninstalling hub...'
	if [ -x "$(which brew)"] ; then
		brew rm hub
	else
		scripted_uninstall
	fi
	report_status
else
	echo 'hub is not installed!'
	exit 2
fi
