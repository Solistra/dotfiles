#!/bin/sh

# =============================================================================
# Functions
# =============================================================================
# report_status()
# -----------------------------------------------------------------------------
#   Checks the exit status of the last run command, reports uninstallation
# status, and exits with either 0 for success or 1 for failure.
# 
# NOTE: This script may also exit with a status of 2 if `goenv` is not
# installed.
report_status(){
	if [ $? -eq 0 ] ; then
		echo 'goenv uninstalled.'
		exit 0
	else
		echo 'goenv could not be uninstalled!'
		echo "Check for remnants in $HOME/.goenv."
		exit 1
	fi
}
# =============================================================================
# Script Body
# =============================================================================
# Uninstall as long as `which goenv` returns a path or the ~/.goenv directory
# exists.
if [ -x "$(which goenv)" ] || [ -d $HOME/.goenv ] ; then
	echo 'Uninstalling goenv...'
	rm -rf $HOME/.goenv
	report_status
else
	echo 'goenv is not installed!'
	exit 2
fi
