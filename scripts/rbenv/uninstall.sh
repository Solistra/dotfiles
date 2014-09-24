#!/bin/sh

# =============================================================================
# Functions
# =============================================================================
# report_status()
# -----------------------------------------------------------------------------
#   Checks the exit status of the last run command, reports uninstallation
# status, and exits with either 0 for success or 1 for failure.
# 
# NOTE: This script may also exit with a status of 2 if `rbenv` is not
# installed.
report_status(){
	if [ $? -eq 0 ] ; then
		echo 'rbenv uninstalled.'
		exit 0
	else
		echo 'rbenv could not be uninstalled!'
		echo "Check for remnants in $loc."
		exit 1
	fi
}
# =============================================================================
# Script Body
# =============================================================================
if [ -x "$(which rbenv)" ] ; then
	echo 'Uninstalling rbenv...'
	loc="$HOME/.rbenv"
	rm -rf $loc
	report_status
else
	echo 'rbenv is not installed!'
	exit 2
fi
